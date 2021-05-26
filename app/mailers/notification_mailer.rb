class NotificationMailer < ApplicationMailer

  def passwordreset_message(mailer)
    @email = mailer

    @url = "https://workeasy.app/session/resetlogin?mail=" + @email
    @signature = "https://workeasy.app/"

    mail(to: @email, subject: 'workeasyのパスワード再設定通知メール', bcc: "info@workeasy.jp")
  end

  def team_success_message(mailer)
    @email = mailer

    @signature = "https://workeasy.app/"
    @reservation = "https://biskett.me/workeasy/45min"

    mail(to: @email, subject: '無料相談日時をお選び下さい', bcc: "info@workeasy.jp")
  end

  def registration_creator_message(mailer)
    @email = mailer

    @signature = "https://workeasy.app/"
    @reservation = "https://biskett.me/workeasy/45min"
    @login = "https://workeasy.app/session/new"

    mail(to: @email, subject: 'workeasyの会員登録が完了しました', bcc: "info@workeasy.jp")
  end

  def registration_enterprise_message(mailer)
    @email = mailer

    @signature = "https://workeasy.app/"
    @reservation = "https://biskett.me/workeasy/45min"
    @createteam = "https://workeasy.app/createteams/categories/new"

    mail(to: @email, subject: 'workeasyの会員登録が完了しました', bcc: "info@workeasy.jp")
  end
end
