# frozen_string_literal: true

module TagsControllerConcern
  extend ActiveSupport::Concern

  def tags_with_count
    @tags = current_user.tags.select("tags.*", "count(*) as count")
      .left_joins(:taggings)
      .left_joins(:source_taggings)
      .left_joins(:author_taggings)
      .group("tags.id")
      .order(Arel.sql("count(*) DESC"))
  end
end
