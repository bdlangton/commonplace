class ImportController < ApplicationController
  def form
  end

  # Import highlights from the kindle website.
  def import
    # Keep track of how many books and highlights are imported.
    authors_count = 0
    books_count = 0
    highlights_count = 0

    # Get the email and password to use and login.
    @email = params[:email]
    @password = params[:password]
    kindle = KindleHighlights::Client.new(
      email_address: @email,
      password: @password
    )

    begin
      @books = kindle.books

      @books.each do |bk|
        # Create or load the author(s).
        @authors = []
        bk_authors = split_authors(bk.author)
        for bk_author in bk_authors
          if Author.where(name: bk_author, user: current_user).empty?
            authors_count += 1
            @author = Author.new(name: bk_author, user: current_user)
            @author.save!
          else
            @author = Author.where(name: bk_author, user: current_user).first
          end
          @authors.push(@author)
        end

        # Create or load the book/source.
        if Source.where(asin: bk.asin, user: current_user).empty?
          books_count += 1
          @book = Source.new(title: bk.title, authors: @authors, source_type: 'Book', asin: bk.asin, user: current_user)
          @book.save!
        else
          @book = Source.where(asin: bk.asin, user: current_user).first
        end

        # Get all highlights from the book.
        @highlights = kindle.highlights_for(bk.asin)
        @highlights.each do |hl|
          # If the highlight says that they are unable to display this kind of
          # content, then skip it. This happens on non-text content such as
          # graphs.
          if hl.text == 'Sorry, we’re unable to display this type of content.'
            next
          end

          # Create the highlight if it doesn't already exist.
          if Highlight.where(highlight: hl.text, location: hl.location, user: current_user, source: @book).empty?
            highlights_count += 1
            @highlight = Highlight.new(highlight: hl.text, note: hl.note, location: hl.location, user: current_user, source: @book)
            @highlight.save!
          elsif hl.note
            # If there is a note in the highlight, but we don't have a note saved
            # locally, then update the highlight.
            @highlight = Highlight.find_by(highlight: hl.text, location: hl.location, user: current_user, source: @book)
            if @highlight.note.empty?
              highlights_count += 1
              @highlight.note = hl.note
              @highlight.save!
            end
          end
        end
      end

      # Redirect to the user's highlights.
      flash[:notice] = "Import finished. #{authors_count} authors added, #{books_count} books added, and #{highlights_count} highlights added."
      redirect_to highlights_path
    rescue KindleHighlights::Client::CaptchaError => error
      # Reload the page and display the captcha error.
      flash[:alert] = error.message
      redirect_to :action => 'form'
    end
  end

  # Upload highlights from a JSON file.
  def upload
    # Keep track of how many books and highlights are imported.
    authors_count = 0
    books_count = 0
    highlights_count = 0

    # Ensure the JSON file can be parsed.
    begin
      bk = JSON(params[:file].read)
    rescue JSON::ParserError
      # Reload the page and display the error.
      flash[:alert] = 'There was a JSON parse error. Please confirm that your file is valid JSON'
      redirect_to :action => 'form'
      return
    end

    # Create or load the author(s).
    @authors = []
    bk_authors = split_authors(bk['authors'])
    for bk_author in bk_authors
      if Author.where(name: bk_author, user: current_user).empty?
        authors_count += 1
        @author = Author.new(name: bk_author, user: current_user)
        @author.save!
      else
        @author = Author.where(name: bk_author, user: current_user).first
      end
      @authors.push(@author)
    end

    # Create or load the book/source.
    if Source.where(asin: bk['asin'], user: current_user).empty?
      books_count += 1
      @book = Source.new(title: bk['title'], authors: @authors, source_type: 'Book', asin: bk['asin'], user: current_user)
      @book.save!
    else
      @book = Source.where(asin: bk['asin'], user: current_user).first
    end

    # Get all highlights from the book.
    @highlights = bk['highlights']
    @highlights.each do |hl|
      # If the highlight says that they are unable to display this kind of
      # content, then skip it. This happens on non-text content such as
      # graphs.
      if hl['text'] == 'Sorry, we’re unable to display this type of content.'
        next
      end

      # Create the highlight if it doesn't already exist.
      if Highlight.where(highlight: hl['text'], location: hl['location']['value'], user: current_user, source: @book).empty?
        highlights_count += 1
        @highlight = Highlight.new(highlight: hl['text'], note: hl['note'], location: hl['location']['value'], url: hl['location']['url'], user: current_user, source: @book)
        @highlight.save!
      elsif hl['note']
        # If there is a note in the highlight, but we don't have a note saved
        # locally, then update the highlight.
        @highlight = Highlight.find_by(highlight: hl['text'], location: hl['location']['value'], user: current_user, source: @book)
        if @highlight.note.empty?
          highlights_count += 1
          @highlight.note = hl['note']
          @highlight.save!
        end
      end
    end

    # Redirect to the user's highlights.
    flash[:notice] = "Upload finished. #{authors_count} authors added, #{books_count} books added, and #{highlights_count} highlights added."
    redirect_to highlights_path
  end

  private
    def split_authors(authors)
      # Get last author separated by "and" if it exists.
      last_author = nil
      if authors.include? " and "
        split = authors.split(' and ')
        authors = split[0]
        last_author = split[1].strip
      end

      # Split the list of authors separated by a comma.
      authors_array = authors.split(',').map { |s| s.strip }

      # If there was an author listed after an "and" then add that here.
      unless last_author.nil?
        authors_array.push(last_author)
      end

      return authors_array
    end
end
