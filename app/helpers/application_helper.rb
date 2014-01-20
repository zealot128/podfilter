module ApplicationHelper
  def markdown(text)
    raw Kramdown::Document.new(text).to_html
  end

  def html_description(text)
    if text['<']
      sanitize text
    else
      simple_format text
    end
  end

  def readable_url(url)
    url.gsub(%r{https?://(www\.)?}, '')
  end
end
