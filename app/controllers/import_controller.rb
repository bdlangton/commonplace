class ImportController < ApplicationController
  def import
    # Keep track of how many books and highlights are imported.
    books_count = 0
    highlights_count = 0

    kindle = KindleHighlights::Client.new(
      email_address: ENV['COMMONPLACE_KINDLE_EMAIL'],
      password: ENV['COMMONPLACE_KINDLE_PW']
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
        # Create the highlight if it doesn't already exist.
        if Highlight.where(highlight: hl.text, location: hl.location, user: @user, source: @book).empty?
          highlights_count += 1
          @highlight = Highlight.new(highlight: hl.text, note: hl.note, location: hl.location, user: @user, source: @book)
          @highlight.save!
        end
      end
    end

    # Redirect to the user's highlights.
    flash[:notice] = "Import finished. #{books_count} books added and #{highlights_count} highlights added."
    redirect_to highlights_path
  end
end
