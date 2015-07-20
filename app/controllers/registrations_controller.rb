class RegistrationsController < Devise::RegistrationsController

  def update
    # setting the new_params variable
    @new_params = params.require(:user).permit(:email,:name,:role,
    :username, :current_password, :password,
    :password_confirmation)
    @change_password = true

    if params[:user][:password].blank?

      params[:user].delete("password")
      params[:user].delete("password_confirmation")
      if is_not_premium
        @new_params = params.require(:user).permit(:email,:role,:name,:username)
      else
        @new_params = params.require(:user).permit(:email,:name,:username,)
      end
      @change_password = false

    end


    @user = User.find(current_user.id)

    if is_not_premium
      if params[:user][:role] == "standard" && @user.role == "premium"

        current_user.wikis.update_all(:private => false)
      end

      password_need
      set_flash_message :notice, :updated
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)

    else
      password_need
      redirect_to "/charges/new"
    end

  end

    def is_not_premium
      params[:user][:role] == "standard" || params[:user][:role] == @user.role
    end
    def password_need
      if @change_password
        @user.update_with_password(@new_params)
      else
       @user.update_without_password(@new_params)
      end
    end



end
