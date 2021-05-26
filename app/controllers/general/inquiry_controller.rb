class General::InquiryController < ApplicationController
  def general
  end

  def consult
  end
  
  def inquirysent
  end

  def create
    InquiryMailer.inquiry_message(inquiry_params).deliver_now
    flash.alert =  "お問い合わせ内容を送信しました"
    redirect_to inquirysent_general_inquiry_index_path
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:username, :company, :current_position, :furigana, :email, :reason, :telephone, :title, :description, :bcc)
  end

end
