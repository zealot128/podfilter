module ApplicationHelper
  def markdown(text)
    raw Kramdown::Document.new(text).to_html
  end

  def html_description(text)
    return "" if text.blank?
    if text['<']
      sanitize text
    else
      simple_format text
    end
  end

  def readable_url(url)
    url.gsub(%r{https?://(www\.)?}, '')
  end

  def page_title
    [
      'Podfilter' ,
      @title || t("#{controller_name}.#{action_name}.page_title", default: t('page_slogan'))
    ].join(' | ')
  end
end
