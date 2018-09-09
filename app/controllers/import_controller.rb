class ImportController < ApplicationController
  def import
    kindle = KindleHighlights::Client.new(
      email_address: ENV['COMMONPLACE_KINDLE_EMAIL'],
      password: ENV['COMMONPLACE_KINDLE_PW']
    )
    @user = User.find(1)
    @books = kindle.books
    @books.each do |bk|
      # Create or load the book.
      if Source.where(asin: bk.asin, user: @user).empty?
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
          @highlight = Highlight.new(highlight: hl.text, location: hl.location, user: @user, source: @book)
          @highlight.save!
        end
      end
    end

    # Redirect to the user's highlights.
    redirect_to highlights_path
  end
end
