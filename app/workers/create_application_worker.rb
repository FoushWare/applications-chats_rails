# create application worker
class CreateApplicationWorker
  include Sidekiq::Worker
  # sidekiq options
  sidekiq_options :retry => false

  def perform(name)
    @application = Application.new(
      name: name,
    )

    # if there is not erros before save generate a token and save the application
    @application.token = SecureRandom.hex(10)

    # Save the application
    if @application.save
    else
      raise "Error"
      # Rasie an error
    end
  end
end
