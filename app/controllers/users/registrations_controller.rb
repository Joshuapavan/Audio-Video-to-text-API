class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private
  def respond_with(resource, options = {})
    if resource.persisted?
      render json:{
        message: "Signed up successfully.",
        data: resource
      }, status: :created
    else
      render json:{
        message: "Unable to sign up.",
        error: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
    
  end
end
