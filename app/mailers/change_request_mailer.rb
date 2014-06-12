class ChangeRequestMailer < ActionMailer::Base

  def cr(cr)
    @cr = cr
    mail to: 'info@podfilter.de', subject: '[Podfilter] Change-Request'
  end

  def notify(cr)
    @cr = cr
    mail to: cr.email, subject: '[Podfilter] Change-Request umgesetzt'
  end
end
