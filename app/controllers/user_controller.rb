class UserController < ApplicationController
  before_action :check_user

  def page
    @page = User.paginate(:page => params[:num], :per_page => params[:per_page])
    render 'users/page'
  end

  def details
    @user = User.where(:email => params[:email]).first
    @roles = Role.all.map{|r| {:name => r.name}}
    render 'users/details'
  end

  def add_role
    user = User.where(:email => params[:user_role][:email]).first
    user.add_role params[:user_role][:role]
    redirect_to '/user?email='+user.email
  end

  def remove_role
    user = User.where(:email => params[:email]).first
    user.remove_role params[:role]
    redirect_to '/user?email='+user.email
  end
end