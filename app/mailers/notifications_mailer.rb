class NotificationsMailer < ActionMailer::Base
  default :from => "josh.m.duffy@gmail.com"
  default :to => "jduffy@mymail.mines.edu"

  def new_message(message)
    @message = message
    mail(:subject => "Example Subject")
  end

  def report_abuse_message(message)
    @message = message
    mail(:subject => "Report Abuse Test")
  end

  def welcome_email(parent)
    @parent = parent
    mail(to: @parent.email, subject: 'Welcome to HealthMonster')
  end
end
