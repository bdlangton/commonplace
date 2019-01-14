require 'bundler'
require 'kindle_highlights'
require 'fileutils'
require 'json'
require 'cgi'
require 'mail'
require 'htmlentities'
# require 'config/environment'

Mail.defaults do
  delivery_method :smtp,
    address: 'smtp.gmail.com',
    port: 587,
    domain: 'gmail.com',
    user_name: ENV['GMAIL_USERNAME'],
    password: ENV['GMAIL_PASSWORD'],
    authentication: 'plain',
    enable_starttls_auto: true
end

class Kindle
  def random_highlights(favorites = 2, any = 1)
    random = Set[]
    count = 0

    # Get just favorited highlights.
    favorite_highlights = Highlight.where(favorite: true, published: true)
    while count < favorites
      offset = rand(favorite_highlights.count)
      if random.add?(favorite_highlights.offset(offset).first)
        count += 1
      end
    end

    # Get any highlights.
    highlights = Highlight.where(published: true)
    while count < favorites + any
      offset = rand(highlights.count)
      if random.add?(highlights.offset(offset).first)
        count += 1
      end
    end
    return random
  end
end

task :email => :environment do
  data = Kindle.new
  highlights = data.random_highlights(2, 1)

  mail = Mail.new do
    from 'Kindle Highlights <bdlangton@gmail.com>'
    to ENV['TO']
    subject "Your daily highlights for #{Time.now.strftime("%b %-d")}"
    html_part do
      content_type 'text/html; charset=UTF-8'

      text = ''
      highlights.each do |highlight|
        tags = highlight.all_tags
        unless tags.empty?
          tags = "<p>Tags: #{tags}</p>"
        end
        text << "<p><b>#{highlight.source.title}</b></p>"
        text << "<p>#{highlight.highlight}</p>"
        unless highlight.note.empty?
          text << "<p>Note: #{highlight.note}</p>"
        end
        text << "#{tags}"
      end
      body text
    end
  end

  mail.deliver
end

task default: [:email]
