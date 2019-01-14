class ImportController < ApplicationController
  def form
  end

  # Import highlights from the kindle website.
  def import
    # Keep track of how many books and highlights are imported.
    books_count = 0
    highlights_count = 0

    # Get the email and password to use and login.
    @email = params[:email]
    @password = params[:password]
    kindle = KindleHighlights::Client.new(
      email_address: @email,
      password: @password
    )
    @user = User.find(1)
    @books = kindle.books
    @books.each do |bk|
      # Create or load the book.
      if Source.where(asin: bk.asin, user: @user).empty?
        books_count += 1
        @book = Source.new(title: bk.title, author: bk.author, source_type: 'Book', asin: bk.asin, user: @user)
        @book.save!
      else
        @book = Source.where(asin: bk.asin).first
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
        if Highlight.where(highlight: hl.text, location: hl.location, user: @user, source: @book).empty?
          highlights_count += 1
          @highlight = Highlight.new(highlight: hl.text, note: hl.note, location: hl.location, user: @user, source: @book)
          @highlight.save!
        elsif hl.note
          # If there is a note in the highlight, but we don't have a note saved
          # locally, then update the highlight.
          @highlight = Highlight.find_by(highlight: hl.text, location: hl.location, user: @user, source: @book)
          if @highlight.note.empty?
            highlights_count += 1
            @highlight.note = hl.note
            @highlight.save!
          end
        end
      end
    end

    # Redirect to the user's highlights.
    flash[:notice] = "Import finished. #{books_count} books added and #{highlights_count} highlights added."
    redirect_to highlights_path
  end
end
