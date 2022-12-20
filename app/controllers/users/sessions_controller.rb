class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private
  def respond_with(resource, options = {})
      render json:{
        message: "Logged in successfully.",
        user: current_user
      }, status: :created
  end

  def respond_to_on_destroy(resource, options = {})
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' '),Rails.application.credentials.fetch(:secret_key_base)).first
    current_user = User.find(jwt_payload['sub'])
    if current_user
      render :json{
        message: 'Logged out successfully'
      },status: :ok
    else
      render :json{
        message: 'User has no active session',
        error: current_user
      }, status: :unauthorized
    end
  end
end
