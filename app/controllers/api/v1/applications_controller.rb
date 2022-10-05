class Api::V1::ApplicationsController < ApplicationController
  # require application Worker

  # Resource for the API to create a new application
  # POST /api/v1/applications
  def create
    # Create a new application
    CreateApplicationWorker.perform_async(application_params.to_h)

    # read from redis cache
    # op2 = $redis.get(application_params[:name])

    # if op2 is not nil return the application
    # if op2
    # render json: { token: op2 }, status: :created
    # end
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
    # Get the application
    @application = Application.find(params[:id])

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
  # DELETE /api/v1/applications/:id
  def destroy
    # Get the application
    @application = Application.find(params[:id])

    # Delete the application
    @application.destroy

    # Return the application
    render json: @application
  end

  private

  # Strong parameters for the application
  def application_params
    params.require(:application).permit(:name)
  end
end
