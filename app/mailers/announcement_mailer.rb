class AnnouncementMailer < ApplicationMailer
  def registration_enterprise_message(mailer)
    @email = mailer

    @signature = "https://workeasy.app/"
    @createteams = "https://workeasy.app/createteams/categories/new"
    @reservation = "https://biskett.me/workeasy/45min"

    mail(to: "info@workeasy.jp", subject: '企業（エンタープライズ）から新規登録がありました')
  end

  def registration_creator_message(mailer)
    @email = mailer

    @signature = "https://workeasy.app/"
    @login = "https://workeasy.app/session/new"
    @reservation = "https://biskett.me/workeasy/45min"

    mail(to: "info@workeasy.jp", subject: 'クリエイターから新規登録がありました')
  end

  def team_request_message(mailer)
    @email = mailer
    @user = User.find_by(email: @email)
    @team = Project.find_by(client_id: @user.id)

    @signature = "https://workeasy.app/"

    mail(to: "info@workeasy.jp", subject: '【重要】新規案件無料相談のお問い合わせがあります')
  end

  def creator_interested_message(mailer, project)
    @email = mailer
    @user = User.find_by(email: @email)
    @project = Project.find(project)

    @signature = "https://workeasy.app/"

    mail(to: "info@workeasy.jp", subject: @user.username + "様がプロジェクト" + @project.title + "に興味があると回答しました")
  end
  
  def sns_registration_message(mailer)
    @email = mailer
    @user = User.find_by(email: @email)

    @signature = "https://workeasy.app/"

    mail(to: "info@workeasy.jp", subject: 'SNSを通じて新規登録がありました')
  end
end
