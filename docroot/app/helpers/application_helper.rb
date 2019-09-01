module ApplicationHelper
  # Given a comma separated list of tags, generate links for each tag.
  def tag_links(tags)
    # The tags may be a comma separated list of values or an ActiveRecord
    # CollectionProxy.
    if tags.is_a? String
      tags.split(",").map{|tag|
        @tag = Tag.find_by(title: tag.strip, user: current_user)
        link_to @tag.title, tag_path(@tag.id), class: ['badge', 'badge-pill', 'badge-success', 'tag'] if @tag
      }.join('')
    else
      tags.map{|tag|
        link_to tag.title, tag_path(tag.id), class: ['badge', 'badge-pill', 'badge-success', 'tag']
      }.join('')
    end
  end
end
