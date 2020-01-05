# frozen_string_literal: true

# Import controller.
class ImportController < ApplicationController
  def form; end

  # Import highlights from the kindle website.
  def import
    # Keep track of how many books and highlights are imported.
    @authors_count = 0
    @books_count = 0
    @highlights_count = 0
    @highlights_updated = 0

    # Get the email and password to use and login.
    @email = params[:email]
    @password = params[:password]
    kindle = KindleHighlights::Client.new(
      email_address: @email,
      password: @password,
    )

    begin
      @books = kindle.books
      import_books("kindle")
    rescue KindleHighlights::Client::CaptchaError => error
      # Reload the page and display the captcha error.
      flash[:alert] = error.message
      redirect_to action: "form"
      return
    end

    # Redirect to the user's highlights.
    flash[:notice] = "Import finished. #{@authors_count} authors added, #{@books_count} books added, #{@highlights_count} highlights added, and #{@highlights_updated} highlights updated."
    redirect_to highlights_path
  end

  # Upload highlights from a JSON file.
  def upload
    # Keep track of how many books and highlights are imported.
    @authors_count = 0
    @books_count = 0
    @highlights_count = 0
    @highlights_updated = 0

    # Ensure the JSON file can be parsed.
    begin
      bk = JSON(params[:file].read)
      @books = [bk]
      import_books("json")
    rescue JSON::ParserError
      # Reload the page and display the error.
      flash[:alert] = "There was a JSON parse error. Please confirm that your file is valid JSON"
      redirect_to action: "form"
      return
    end

    # Redirect to the user's highlights.
    flash[:notice] = "Upload finished. #{@authors_count} authors added, #{@books_count} books added, #{@highlights_count} highlights added, and #{@highlights_updated} highlights updated."
    redirect_to highlights_path
  end

  private
    # Import array of books.
    def import_books(type = "kindle")
      @books.each do |bk|
        unless bk.kind_of?(Array) || bk.kind_of?(Hash)
          bk = bk.to_a
          bk["authors"] = bk["author"]
        end

        # Create or load the author(s).
        authors = import_authors(bk)

        # Create or load the book/source.
        book = import_book(bk, authors)

        # Get all highlights from the book.
        if type == "kindle"
          highlights = kindle.highlights_for(book.asin)
        else
          highlights = bk["highlights"]
        end

        # Import all highlights.
        import_highlights(highlights, book)
      end
    end

    # Import author(s).
    def import_authors(book)
      authors = []
      bk_authors = split_authors(book["authors"])
      bk_authors.each do |bk_author|
        existing_author = Author.where(name: bk_author, user: current_user)
        if existing_author.empty?
          @authors_count += 1
          author = Author.new(name: bk_author, user: current_user)
          author.save!
        else
          author = existing_author.first
        end
        authors.push(author)
      end
      authors
    end

    # Import a book.
    def import_book(bk, authors)
      existing_source = Source.where(asin: bk["asin"], user: current_user)
      if existing_source.empty?
        @books_count += 1
        book = Source.new(title: bk["title"], authors: authors, source_type: "Book", asin: bk["asin"], user: current_user)
        book.save!
      else
        book = existing_source.first
      end
      book
    end

    # Import array of highlights for a book.
    def import_highlights(highlights, book)
      highlights.each do |hl|
        # Convert kindle highlight objects to array like the JSON upload is.
        unless hl.kind_of?(Array) || hl.kind_of?(Hash)
          hl = hl.to_a
          hl["location"]["value"] = hl["location"]
          hl["location"]["url"] = hl["url"]
        end

        # If the highlight says that they are unable to display this kind of
        # content, then skip it. This happens on non-text content such as
        # graphs.
        if hl["text"] == "Sorry, we’re unable to display this type of content."
          next
        end

        # Create the highlight if it doesn't already exist.
        if Highlight.where(location: hl["location"]["value"], user: current_user, source: book).empty?
          add_highlight(hl, book)
        else
          update_highlight(hl, book)
        end
      end
    end

    # Add a new highlight.
    def add_highlight(hl, book)
      @highlights_count += 1
      if hl["isNoteOnly"] && hl["text"].empty?
        hl["text"] = "*Note only*"
      end
      highlight = Highlight.new(highlight: hl["text"], note: hl["note"], location: hl["location"]["value"], url: hl["location"]["url"], user: current_user, source: book)
      highlight.save!
    end

    # Update an existing highlight (if needed).
    def update_highlight(hl, book)
      highlight = Highlight.find_by(location: hl["location"]["value"], user: current_user, source: book)

      # If we need to update the current highlight.
      update = false

      # If there is a note in the highlight, but we don't have a note saved
      # locally, then update the highlight.
      if hl["note"]
        if highlight.note.nil?
          update = true
          highlight.note = hl["note"]
        end
      end

      # If there is a kindle URL in the highlight, but we don't have the URL
      # saved locally, then update the highlight.
      if hl["location"]["url"]
        if highlight.url.nil?
          update = true
          highlight.url = hl["location"]["url"]
        end
      end

      # Save the highlight if anything was updated.
      if update
        @highlights_updated += 1
        highlight.save!
      end
    end

    # Split string of authors into an array.
    def split_authors(authors)
      # Get last author separated by "and" if it exists.
      last_author = nil
      if authors.include? " and "
        split = authors.split(" and ")
        authors = split[0]
        last_author = split[1].strip
      end

      # Split the list of authors separated by a comma.
      authors_array = authors.split(",").map { |s| s.strip }

      # If there was an author listed after an "and" then add that here.
      unless last_author.nil?
        authors_array.push(last_author)
      end

      authors_array
    end
end
