class User < ApplicationRecord
  has_secure_password

  mount_uploader :picture, ImageUploader

  has_many :team_members
  has_many :teams, foreign_key: :user_id, dependent: :destroy, through: :team_members
  accepts_nested_attributes_for :team_members, allow_destroy: true

  has_many :member_skills
  has_many :skills, through: :member_skills

  has_one :detail, dependent: :destroy, inverse_of: :user
  accepts_nested_attributes_for :detail, allow_destroy: true

  has_many :careers, dependent: :destroy, inverse_of: :user
  accepts_nested_attributes_for :careers, reject_if: :all_blank, allow_destroy: true

  has_one :paperclip, dependent: :destroy, inverse_of: :user
  accepts_nested_attributes_for :paperclip, reject_if: :all_blank, allow_destroy: true

  has_many :licenses, dependent: :destroy, inverse_of: :user
  accepts_nested_attributes_for :licenses, reject_if: :all_blank, allow_destroy: true

  attr_accessor :lastname, :firstname
  before_validation :set_username

  attr_accessor :eng_lastname, :eng_firstname
  before_validation :set_englishname

  # minimagikを使用したファイルのアップロードはこれを使う
  # has_one_attached :profile_pic
  # attribute :new_profile_picture
  #
  # before_save do
  #   if new_profile_picture
  #     self.profile_pic = new_profile_picture
  #   end
  # end

  def self.from_omniauth(auth)
    user = User.where('email = ?', auth.info.email).first
    if user.blank?
      user = User.new
      user.uid   = auth.uid
      user.username = auth.info.name
      if auth.provider == "facebook"
        @firstname  = auth.info.first_name
        @lastname  = auth.info.last_name
        user.username = [@lastname, @firstname].join(" ")
      end
      user.email = auth.info.email
      user.password = "12345678"
      user.role = 1
      user.picture_url = auth.info.image
      user.oauth_token = auth.credentials.token
      unless ( auth.provider == "github" or auth.provider == "twitter" )
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      end
      user.detail = Detail.new
      user
    end
  end

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end

  def firstname
    @firstname || self.username.split(" ").last if self.username.present?
  end

  def lastname
    @lastname || self.username.split(" ").first if self.username.present?
  end

  #DBカラムはusernameなので@firstname, @lastnameを結合する
  def set_username
    unless @firstname == nil
      self.username = [@lastname, @firstname].join(" ")
    end
  end

  def eng_firstname
    @eng_firstname || self.english_name.split(" ").last if self.english_name.present?
  end

  def eng_lastname
    @eng_lastname || self.english_name.split(" ").first if self.english_name.present?
  end

  #DBカラムはenglish_nameなので@eng_firstname, @eng_lastnameを結合する
  def set_englishname
    unless @eng_firstname == nil
      self.english_name = [@eng_lastname, @eng_firstname].join(" ")
    end
  end
end
