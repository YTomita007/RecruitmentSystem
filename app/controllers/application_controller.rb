class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :current_user
  before_action :judge_status

  def current_user
    remember_token = User.encrypt(cookies[:user_remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
    unless @current_user.nil?
      if @current_user.picture.present?
        if Rails.env == 'production'
          @facelogo = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com/' + @current_user.picture.path
        else
          @facelogo = 'https://workeasy-dev.s3-ap-northeast-1.amazonaws.com/' + @current_user.picture.path
        end
      end
    end
  end

  def judge_status
    unless @current_user.nil?
      @judge = false
      unless @current_user.detail.projectmanager.nil? or @current_user.detail.webdesigner.nil? or @current_user.detail.uiuxdesigner.nil? or @current_user.detail.frontendengineer.nil? or @current_user.detail.backendengineer.nil?
        unless @current_user.picture.nil?
          unless @current_user.detail.telephone.nil?
            unless @current_user.detail.birthday.nil?
              unless @current_user.detail.gender.nil?
                unless @current_user.detail.availability.nil?
                  unless @current_user.detail.schedule.nil?
                    unless @current_user.detail.hourly_rate.nil?
                      unless @current_user.member_skills.empty?
                        @judge = true
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  helper_method :current_user

  class LoginRequired < StandardError; end
  class Forbidden < StandardError; end
  class RequestEntityTooLarge < StandardError; end
  class GatewayTimeOut < StandardError; end

  if Rails.env.production? || ENV["RESCUE_EXCEPTIONS"]
    rescue_from StandardError, with: :rescue_internal_server_error
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_found
    rescue_from ActionController::ParameterMissing, with: :rescue_bad_request
  end

  rescue_from LoginRequired, with: :rescue_login_required
  rescue_from Forbidden, with: :rescue_forbidden
  rescue_from RequestEntityTooLarge, with: :rescue_request_entity_too_large
  rescue_from GatewayTimeOut, with: :rescue_gateway_time_out

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:user_remember_token] = remember_token
    user.update!(remember_token: User.encrypt(remember_token))
    @current_user = user
  end

  def sign_out
    @current_user = nil
    cookies.delete(:user_remember_token)
  end

  def signed_in?
    @current_user.present?
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def login_required
    raise LoginRequired unless current_user
  end

  def rescue_bad_request(exception)
    render "errors/bad_request", status: 400, layout: "error",
      formats: [:html]
  end

  def rescue_forbidden(exception)
    render "errors/forbidden", status: 403, layout: "error",
      formats: [:html]
  end

  def rescue_login_required(exception)
    render "errors/login_required", status: 403, layout: "error",
      formats: [:html]
  end

  def rescue_not_found
    render "errors/not_found", status: 404, layout: "error",
      formats: [:html]
  end

  def rescue_request_entity_too_large
    render "errors/request_entity_too_large", status: 413, layout: "error",
      formats: [:html]
  end

  def rescue_gateway_time_out
    render "errors/gateway_time_out", status: 504, layout: "error",
      formats: [:html]
  end

  def rescue_internal_server_error(exception)
    render "errors/internal_server_error", status: 500, layout: "error",
      formats: [:html]
  end

end
