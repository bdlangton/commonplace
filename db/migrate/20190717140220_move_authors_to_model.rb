class MoveAuthorsToModel < ActiveRecord::Migration[5.1]
  def change
    Source.find_each do |source|
      # Skip over results with blank authors.
      if source.author.empty?
        continue
      end

      # Find or create a new author.
      @author = Author.find_by_name(source.author)
      if @author.nil?
        @author = Author.new(name: source.author, user_id: source.user_id)
        @author.save!
      end

      # Save the author reference to the source.
      source.authors = [@author]
      source.save!
    end
  end
end
