class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  layout 'session', only: [:new, :create, :select_gestion]

  def new
    redirect_to admin_root_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password]) && user.active?
      session[:user_id] = user.id
      
      # Check for a previously selected gestion
      if user.current_gestion
        redirect_to admin_root_path, notice: "Welcome back, #{user.full_name}"
      else
        # If no current gestion, proceed to selection logic
        user_gestions = user.gestions.active
        
        if user_gestions.count == 1
          # Auto-select if there's only one option
          user.set_current_gestion(user_gestions.first.id)
          redirect_to admin_root_path, notice: "Welcome, #{user.full_name}"
        else
          # Redirect to selection page if multiple or no options
          redirect_to select_gestion_path
        end
      end
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    @current_user = nil
    redirect_to login_path, notice: "Logged out successfully"
  end

  def select_gestion
    @gestions = current_user.gestions.active
    if @gestions.empty?
      session[:user_id] = nil
      redirect_to login_path, alert: "You do not have access to any active gestion."
    end
  end

  def set_gestion
    gestion = current_user.gestions.active.find_by(id: params[:gestion_id])
    
    if gestion
      current_user.set_current_gestion(gestion.id)
      redirect_to admin_root_path, notice: "Gestion selected: #{gestion.name}"
    else
      redirect_to admin_root_path, alert: "Invalid gestion selected."
    end
  end
end
