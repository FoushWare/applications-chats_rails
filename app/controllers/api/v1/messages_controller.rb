class Api::V1::MessagesController < ApplicationController
  # POST /api/v1/messages
  def create
    # Create a new message
    # Params:
    #   application_token:
    #   chat_number: number of the chat in that application (starts from 1)
    #   body: body of the message
    # Returns:
    #   message_number: number of the message in that chat (starts from 1)
    #   application_token: token of the application
    #   chat_number: number of the chat that the message belongs to

    # Check if the application exists
    # if it exists then check if the chat exists
    # if it exists then create a new message
    # if it doesn't exist then return an error
    # if the application doesn't exist then return an error
    application = Application.find_by(token: params[:application_token])
    if application.nil?
      render json: { error: "Application not found" }, status: :not_found
      return
    end

    chat = Chat.find_by(number: params[:chat_number], application_id: application.id)
    if chat.nil?
      render json: { error: "Chat not found" }, status: :not_found
      return
    end

    @message = Message.new(body: params[:body], chat_id: chat.id)
    @message.number = chat.messages_count + 1
    @message.application_token = application.token

    # transaction is used to make sure that the message is created and the chat is updated
    # if one of them fails then the other one is rolled back
    Message.transaction do
      @messageSave = @message.save!
    end

    if @messageSave
      render json: { message_number: @message.number, application_token: application.token, body: @message.body, chat_number: chat.number }, status: :created
    else
      render json: { error: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  #  # GET /api/v1/messages/?application_token="...."&chat_number="...."
  def index
    # Get all the messages for a chat
    # Params:
    #   application_token:
    #   chat_number: number of the chat in that application (starts from 1)
    # Returns:
    #   messages: array of messages
    #   application_token: token of the application
    #   chat_number: number of the chat that the messages belong to

    # Check if the application exists
    # if it exists then check if the chat exists
    # if it exists then get all the messages for that chat
    # if it doesn't exist then return an error
    # if the application doesn't exist then return an error
    application = Application.find_by(token: params[:application_token])
    if application.nil?
      render json: { error: "Application not found" }, status: :not_found
      return
    end

    chat = Chat.find_by(number: params[:chat_number], application_id: application.id)
    if chat.nil?
      render json: { error: "Chat not found" }, status: :not_found
      return
    end

    messages = chat.messages
    # loop through the messages and create a response
    @messagesRes = []
    messages.each do |message|
      @messagesRes.push({
        number: message.number,
        body: message.body,
        chat_id: message.chat_id,
      })
    end

    render json: { messages: @messagesRes, application_token: application.token, chat_number: chat.number }, status: :ok
  end

  #  # GET /api/v1/messages/:id/?application_token="...."&chat_number="...."
  def show
    # Get a message
    # Params:
    #   application_token:
    #   chat_number: number of the chat in that application (starts from 1)
    #   message_number: number of the message in that chat (starts from 1)
    # Returns:
    #   message: the message
    #   application_token: token of the application
    #   chat_number: number of the chat that the message belongs to

    # Check if the application exists
    # if it exists then check if the chat exists
    # if it exists then check if the message exists
    # if it exists then get the message
    # if it doesn't exist then return an error
    # if the application doesn't exist then return an error
    application = Application.find_by(token: params[:application_token])
    if application.nil?
      render json: { error: "Application not found" }, status: :not_found
      return
    end

    chat = Chat.find_by(number: params[:chat_number], application_id: application.id)
    if chat.nil?
      render json: { error: "Chat not found" }, status: :not_found
      return
    end

    message = Message.find_by(number: params[:id], chat_id: chat.id)
    if message.nil?
      render json: { error: "Message not found" }, status: :not_found
    else
      @messageRes = {
        messageNumber: message.number,
        body: message.body,
        chatNumber: chat.number,
      }
      render json: { message: @messageRes, application_token: application.token, chat_number: chat.number }, status: :ok
    end
  end

  #  # PUT /api/v1/messages/:id/?application_token="...."&chat_number="...."
  def update
    # Update a message
    # Params:
    #   application_token:
    #   chat_number: number of the chat in that application (starts from 1)
    #   message_number: number of the message in that chat (starts from 1)
    #   body: body of the message
    # Returns:
    #   message_number: number of the message in that chat (starts from 1)
    #   application_token: token of the application
    #   chat_number: number of the chat that the message belongs to

    # Check if the application exists
    # if it exists then check if the chat exists
    # if it exists then check if the message exists
    # if it exists then update the message
    # if it doesn't exist then return an error
    # if the application doesn't exist then return an error
    application = Application.find_by(token: params[:application_token])
    if application.nil?
      render json: { error: "Application not found" }, status: :not_found
      return
    end

    chat = Chat.find_by(number: params[:chat_number], application_id: application.id)
    if chat.nil?
      render json: { error: "Chat not found" }, status: :not_found
      return
    end

    message = Message.find_by(number: params[:message_number], chat_id: chat.id)
    if message.nil?
      render json: { error: "Message not found" }, status: :not_found
      return
    end

    if message.update(body: params[:body])
      render json: { message_number: message.number, application_token: application.token, chat_number: chat.number }, status: :ok
    else
      render json: { error: message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  #  # DELETE /api/v1/messages/:id/?application_token="...."&chat_number="...."
  def destroy
    # Delete a message
    # Params:
    #   application_token:
    #   chat_number: number of the chat in that application (starts from 1)
    #   message_number: number of the message in that chat (starts from 1)
    # Returns:
    #   message_number: number of the message in that chat (starts from 1)
    #   application_token: token of the application
    #   chat_number: number of the chat that the message belongs to

    # Check if the application exists
    # if it exists then check if the chat exists
    # if it exists then check if the message exists
    # if it exists then delete the message
    # if it doesn't exist then return an error
    # if the application doesn't exist then return an error
    application = Application.find_by(token: params[:application_token])
    if application.nil?
      render json: { error: "Application not found" }, status: :not_found
      return
    end

    chat = Chat.find_by(number: params[:chat_number], application_id: application.id)
    if chat.nil?
      render json: { error: "Chat not found" }, status: :not_found
      return
    end

    message = Message.find_by(number: params[:message_number], chat_id: chat.id)
    if message.nil?
      render json: { error: "Message not found" }, status: :not_found
      return
    end

    if message.destroy
      # Update the numbers of the messages after the deleted message
      messages = Message.where("chat_id = ? AND number > ?", chat.id, message.number)
      messages.each do |message|
        # if the message is the last message in the chat then update the last_message_number of the chat
        if message.number == chat.last_message_number
          chat.update(last_message_number: message.number - 1)
        end
        # update the number of the message by subtracting 1
        message.update(number: message.number - 1)
      end

      render json: { message_number: message.number, application_token: application.token, chat_number: chat.number }, status: :ok
    else
      render json: { error: message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # search in the messages of a chat
  #  # GET /api/v1/messages/search/?application_token="...."&chat_number="...."&query="...."
  def search
    # Search in the messages of a chat
    # Params:
    #   application_token:
    #   chat_number: number of the chat in that application (starts from 1)
    #   query: the query to search for
    # Returns:
    #   messages: the messages that contain the query
    #   application_token: token of the application
    #   chat_number: number of the chat that the messages belong to

    # Check if the application exists
    # if it exists then check if the chat exists
    # if it exists then search in the messages of the chat
    # if it doesn't exist then return an error
    # if the application doesn't exist then return an error
    application = Application.find_by(token: params[:application_token])
    if application.nil?
      render json: { error: "Application not found" }, status: :not_found
      return
    end

    # chat = Chat.find_by(number: params[:chat_number], application_id: application.id)
    # if chat.nil?
    #   render json: { error: "Chat not found" }, status: :not_found
    #   return
    # end

    # messages = Message.where("chat_id = ? AND body LIKE ?", chat.id, "%#{params[:query]}%")
    # render json: { messages: messages, application_token: application.token, chat_number: chat.number }, status: :ok
    unless params[:query].blank?
      puts "query:----------------------------> #{params[:query]}"
      # search in the messages of the chat
      results = Message.searchMessages(params[:query])
      render json: { result: results }, status: :ok
      # render json: { messages: results, application_token: application.token, chat_number: chat.number }, status: :ok
    end
  end
end
