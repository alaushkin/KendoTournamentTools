class UserUtils
  def check_sign
    if !user_signed_in?
      redirect_to '/sign_in'
      return false
    end
    return true
  end
end