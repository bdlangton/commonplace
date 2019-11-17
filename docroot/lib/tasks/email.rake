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
    address: "smtp.gmail.com",
    port: 587,
    domain: "gmail.com",
    user_name: ENV["GMAIL_USERNAME"],
    password: ENV["GMAIL_PASSWORD"],
    authentication: "plain",
    enable_starttls_auto: true
end

class Kindle
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
    highlights = data.random_highlights(user)

    # Skip this user if they have no highlights return.
    if highlights.empty?
      next
    end

    text = ""
    mail = Mail.new do
      from "Commonplace Book <barrett@langton.dev>"

      to user.email
      subject "Your daily highlights for #{Time.now.strftime("%b %-d")}"
      html_part do
        content_type "text/html; charset=UTF-8"

        highlights.each do |highlight|
          if highlight.blank?
            next
          end

          tags = highlight.all_tags
          unless tags.empty?
            tags = "<p>Tags: #{tags}</p>"
          end
          text << "<p><b>#{highlight.source.title}</b></p>"
          text << "<p>#{highlight.highlight}</p>"
          if highlight.note.present?
            text << "<p>Note: #{highlight.note}</p>"
          end
          text << "#{tags}"
        end
        body text
      end
    end

    mail.deliver unless text.empty?
  end
end

task default: [:email]
