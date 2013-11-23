module ApplicationHelper
  def markdown(text)
    raw Kramdown::Document.new(text).to_html
  end
end
