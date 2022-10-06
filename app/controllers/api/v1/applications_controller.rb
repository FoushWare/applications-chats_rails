class Api::V1::ApplicationsController < ApplicationController
  # require application Worker

  # Resource for the API to create a new application
  # POST /api/v1/applications
  def create
    # Create a new application
    @application = Application.new(application_params)
    # if there is not erros before save generate a token and save the application
    @application.token = SecureRandom.hex(10)

    # Save the application
    if @application.save
      # return only the token and status
      render json: { token: @application.token }, status: :created
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # Resource for the API to get all applications
  # GET /api/v1/applications
  def index
    # Get all applications
    @applications = Application.all

    # Return the applications
    render json: @applications
  end

  # Resource for the API to get a specific application
  # GET /api/v1/applications/:id
  def show
    # Get the application
    @application = Application.find(params[:id])

    # Return the application
    render json: @application
  end

  # Resource for the API to update a specific application
  # PUT /api/v1/applications/:id
  def update
    # Get the application by token
    @application = Application.find_by(token: params[:id])
    # Update the application
    if @application.update(application_params)
      # Return the application
      render json: @application
    else
      # Return the errors
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # Resource for the API to delete a specific application
  # DELETE /api/v1/applications/:token
  def destroy
    # Get the application by token
    @application = Application.find_by(token: params[:id])
    # check if the application exists
    if @application.nil?
      render json: { error: "Application not found" }, status: :not_found
      return
    end
    # Delete the application
    if @application.destroy
      # Return the application token
      render json: { token: @application.token }, status: :ok
    else
      # Return the errors
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters for the application
  def application_params
    params.require(:application).permit(:name)
  end
end
