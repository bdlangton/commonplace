# frozen_string_literal: false

require "bundler"
require "kindle_highlights"
require "fileutils"
require "json"
require "cgi"
require "mail"
require "htmlentities"
# require 'config/environment'

Mail.defaults do
  delivery_method :smtp,
    address: "smtp.fastmail.com",
    port: 587,
    domain: "fastmail.com",
    user_name: ENV["MAIL_USERNAME"],
    password: ENV["MAIL_PASSWORD"],
    authentication: "plain",
    enable_starttls_auto: true
end

class Kindle
  def random_summaries(user)
    summaries = User.email_count(user, "summary")
    random = Set[]
    count = 0
    loops = 0

    # Get summary notes from books/sources.
    source_summaries = Source.by_user(user).where("notes IS NOT NULL AND notes != ''")
    while count < summaries
      offset = rand(source_summaries.count)
      if random.add?(source_summaries.offset(offset).first)
        count += 1
      end

      # Break out if the loop is never finding enough summaries.
      loops += 1
      if loops > summaries * 2
        return random
      end
    end
    random
  end

  def random_highlights(user)
    favorites = User.email_count(user, "favorite")
    any = User.email_count(user, "random")
    random = Set[]
    count = 0
    loops = 0

    # Get just favorited highlights.
    favorite_highlights = Highlight.by_user(user).where(favorite: true, published: true)
    while count < favorites
      offset = rand(favorite_highlights.count)
      if random.add?(favorite_highlights.offset(offset).first)
        count += 1
      end

      # Break out if the loop is never finding enough highlights.
      loops += 1
      if loops > favorites * 2
        return random
      end
    end

    # Get any highlights.
    highlights = Highlight.by_user(user).where(published: true)
    while count < favorites + any
      offset = rand(highlights.count)
      if random.add?(highlights.offset(offset).first)
        count += 1
      end

      # Break out if the loop is never finding enough highlights.
      loops += 1
      if loops > (favorites + any) * 2
        return random
      end
    end
    random
  end
end

task email: :environment do
  # Get users that have opted in to receiving email.
  users = User.all.select { |user| User.receive_email(user) }

  for user in users
    data = Kindle.new
    summaries = data.random_summaries(user)
    highlights = data.random_highlights(user)

    # Skip this user if they have no summaries or highlights return.
    if summaries.empty? && highlights.empty?
      next
    end

    text = ""
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, space_after_headers: true)
    mail = Mail.new do
      from "Commonplace Book <barrett@langton.dev>"

      to user.email
      subject "Your daily highlights for #{Time.now.strftime("%b %-d")}"
      html_part do
        content_type "text/html; charset=UTF-8"

        # Add header for summaries section.
        if !summaries.empty?
          text << markdown.render("# Sources")
        end

        # Go through each summary.
        summaries.each do |summary|
          if summary.blank?
            next
          end

          tags = summary.tags
          if tags.empty?
            tags = ""
          else
            tags = tags.map { |tag|
              "<a href='https://commonplace.langton.dev/tags/" + tag.id.to_s + "'>" + tag.title + "</a>"
            }.join(", ")
            tags = "<p>Tags: #{tags}</p>"
          end

          text << "<p><b>#{summary.title}</b></p>"
          text << "<p>#{markdown.render(summary.notes || '')}</p>"
          text << "#{tags}"
          text << "<a href='https://commonplace.langton.dev/sources/" + summary.id.to_s + "'>Go to source</a>"
        end

        # Add header for highlights section.
        if !highlights.empty?
          text << markdown.render("# Highlights")
        end

        # Go through each highlight.
        highlights.each do |highlight|
          if highlight.blank?
            next
          end

          tags = highlight.tags
          if tags.empty?
            tags = ""
          else
            tags = tags.map { |tag|
              "<a href='https://commonplace.langton.dev/tags/" + tag.id.to_s + "'>" + tag.title + "</a>"
            }.join(", ")
            tags = "<p>Tags: #{tags}</p>"
          end

          text << "<p><b>#{highlight.source.title}</b></p>"
          text << "<p>#{markdown.render(highlight.highlight || '')}</p>"
          if highlight.note.present?
            text << "<p>Note: #{markdown.render(highlight.note || '')}</p>"
          end
          text << "#{tags}"
          text << "<a href='https://commonplace.langton.dev/sources/" + highlight.source_id.to_s + "#highlight-" + highlight.id.to_s + "'>Go to highlight</a>"
        end
        body text
      end
    end

    mail.deliver unless text.empty?
  end
end

task default: [:email]
