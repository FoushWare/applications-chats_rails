# create application worker
class CreateApplicationWorker
  include Sidekiq::Worker
  # sidekiq options
  sidekiq_options :retry => false

  def perform(name)
    # Create a new application
    # @application = Application.new(name: name)
    # make name required
    @application = Application.new(
      name: name,
    )

    # if there is not erros before save generate a token and save the application
    @application.token = SecureRandom.hex(10)

    # Save the application
    if @application.save
      # return the application
      # ApplicationController.render json: @application, status: :created
    else
      raise "Error"
      # Rasie an error
    end
  end
end
