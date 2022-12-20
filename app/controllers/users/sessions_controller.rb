class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private
  def respond_with(response, options = {})
    render json:
    {
      message: "User logged in successfully",
      data: current_user
    },status: :ok
  end

  def respond_to_on_destroy()
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
    current_user = User.find(jwt_payload['sub'])

    if current_user
      render json:
      {
        message: "User has logged out successfully",
        data: current_user
      }, status: :ok
    else
      render json:
      {
        message: "User doesnot hold an account, please sign up."
      }, status: :unauthorized
    end
  end
end
