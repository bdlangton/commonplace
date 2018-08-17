class ImportController < ApplicationController
  def import
    require '/usr/local/lib/ruby/gems/2.5.0/gems/kindle-highlights-2.0.1/lib/kindle_highlights.rb'
    kindle = KindleHighlights::Client.new(
      email_address: "",
      password: ""
    )
    @user = User.find(1)
    @books = kindle.books
    @books.each do |book|
      if Source.where(asin: book.asin).empty?
        puts 'creating book'
        @bk = Source.new(title: book.title, author: book.author, source_type: 'Book', asin: book.asin, user: @user)
        @bk.save!
      else
        puts 'loading book'
        @bk = Source.where(asin: book.asin).first
      end
      hls = kindle.highlights_for(book.asin)
      hls.each do |hl|
        @hlo = Highlight.new(highlight: hl.text, location: hl.location, user: @user, source: @bk)
        @hlo.save!
      end
    end
    # redirect_to highlights_path
  end
end
