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
  def random_highlight
    offset = rand(Highlight.count)
    random = Highlight.offset(offset).first
  end
end

task :email => :environment do
  data = Kindle.new
  highlight = data.random_highlight

  mail = Mail.new do
    from 'Kindle Highlights <bdlangton@gmail.com>'
    to ENV['TO']
    subject "#{Time.now.strftime("%b %d")}: #{highlight.source.title}"
    html_part do
      content_type 'text/html; charset=UTF-8'

      body "<p>#{highlight.highlight}</p><p>&mdash; #{highlight.source.title}</p>"
    end
  end

  mail.deliver
end

task default: [:email]
