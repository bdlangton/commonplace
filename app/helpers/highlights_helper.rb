module HighlightsHelper
  def tag_links(tags)
    tags.split(",").map{|tag|
      @tag = Tag.find_by(title: tag.strip, user: 1)
      link_to @tag.title, tag_path(@tag.id), class: ['badge', 'badge-pill', 'badge-primary'] if @tag
    }.join('')
  end
end
