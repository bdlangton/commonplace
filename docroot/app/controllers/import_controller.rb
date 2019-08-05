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
        # Create or load the author.
        if Author.where(name: bk.author, user: current_user).empty?
          authors_count += 1
          @author = Author.new(name: bk.author, user: current_user)
          @author.save!
        else
          @author = Author.where(name: bk.author, user: current_user).first
        end

        # Create or load the book/source.
        if Source.where(asin: bk.asin, user: current_user).empty?
          books_count += 1
          @book = Source.new(title: bk.title, author: @author, source_type: 'Book', asin: bk.asin, user: current_user)
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
end