class PushSubscriptionsController < ApplicationController
  before_action :require_login

  def create
    subscription = current_user.push_subscriptions.find_or_initialize_by(endpoint: subscription_params[:endpoint])
    subscription.assign_attributes(subscription_params)
    
    if subscription.save
      render json: { success: true }, status: :created
    else
      render json: { errors: subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    subscription = current_user.push_subscriptions.find_by(endpoint: params[:endpoint])
    subscription&.destroy
    head :no_content
  end

  def vapid_public_key
    render json: { publicKey: Rails.application.credentials.dig(:web_push, :vapid_public_key) }
  end

  private

  def subscription_params
    params.require(:subscription).permit(:endpoint, :p256dh, :auth)
  end

  def require_login
    redirect_to login_path unless current_user
  end
end
