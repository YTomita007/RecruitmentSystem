class InquiryMailer < ApplicationMailer

  def inquiry_message(inquiry_params)
    @username = inquiry_params[:username]
    
    @company = inquiry_params[:company]
    @current_position = inquiry_params[:current_position]
    @furigana = inquiry_params[:furigana]
    @reason = inquiry_params[:reason]
    
    @email = inquiry_params[:email]
    @telephone = inquiry_params[:telephone]
    @title = inquiry_params[:title]
    @description = inquiry_params[:description]
    @signature = "https://workeasy.app/"

    if inquiry_params[:bcc] == "1"
      mail(to: "info@workeasy.jp",
          subject: "workeasyへのお問い合わせ",
          bcc: @email
      )
    else
      mail(to: "info@workeasy.jp",
          subject: "新規問い合わせがありました"
      )
    end
  end

end
