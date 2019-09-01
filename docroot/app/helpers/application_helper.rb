module ApplicationHelper
  # Given a comma separated list of tags, generate links for each tag.
  def tag_links(tags)
    tags.split(",").map{|tag|
      @tag = Tag.find_by(title: tag.strip, user: current_user)
      link_to @tag.title, tag_path(@tag.id), class: ['badge', 'badge-pill', 'badge-success', 'tag'] if @tag
    }.join('')
  end
end
