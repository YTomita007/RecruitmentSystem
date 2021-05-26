module SessionsHelper
  def log_in(member)
    session[:login_member] = member_id
  end
end
