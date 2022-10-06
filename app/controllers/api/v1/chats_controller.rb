class Api::V1::ChatsController < ApplicationController
  # Resource for the API to create a new chat

  # POST /api/v1/chats
  def create
    # Create a new chat
    # Params:
    #   name: name of the chat
    #   application_token:
    # Returns:
    # chat_number: number of the chat in that application (starts from 1)
    # application_token: token of the application

    # Check if the application exists
    @application = Application.find_by(token: params[:application_token])
    if @application.nil?
      render json: { error: "Application not found" }, status: :not_found
      return
    end

    # Create a new chat
    @chat = Chat.new(name: params[:name], application_id: @application.id)

    # transaction to save the chat
    Chat.transaction do
      @chatSave = @chat.save!
    end

    if @chatSave
      render json: { chat_number: @chat.number, application_token: @application.token }, status: :created
    else
      render json: { error: chat.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/chats/?application_token="...."
  def index
    # Get all the chats for an application
    # Params:
    #   application_token:
    # Returns:
    #   chats: array of chats
    #   application_token: token of the application

    # Check if the application exists
    application = Application.find_by(token: params[:application_token])
    if application.nil?
      render json: { error: "Application not found" }, status: :not_found
      return
    end
    # Get all the chats for this application
    chats = application.chats
    chatsResponse = []
    chats.each do |chat|
      chatsResponse.push({ name: chat.name, number: chat.number })
    end

    render json: { chats: chatsResponse, application_token: application.token }, status: :ok
  end

  # GET /api/v1/chats/:id/?application_token="...."
  def show
    # Get a chat
    # Params:
    #   chat_number: id of the chat
    #   application_token:
    # Returns:
    #   chat: chat
    #   application_token: token of the application

    # Check if the application exists
    application = Application.find_by(token: params[:application_token])
    if application.nil?
      render json: { error: "Application not found" }, status: :not_found
      return
    end
    # Get the chat by chat number
    chat = application.chats.find_by(number: params[:id])
    if chat.nil?
      render json: { error: "Chat not found" }, status: :not_found
      return
    end
    # Get all the messages for this chat
    chatResponse = {
      number: chat.number,
      name: chat.name,
    }
    render json: { chat: chatResponse, application_token: application.token }, status: :ok
  end

  # PUT /api/v1/chats/:id/?application_token="...."
  def update
    # Update a chat
    # Params:
    #   chat_number: id of the chat
    #   name: name of the chat
    #   application_token:
    # Returns:
    #   chat: chat
    #   application_token: token of the application

    # Check if the application exists
    application = Application.find_by(token: params[:application_token])
    if application.nil?
      render json: { error: "Application not found" }, status: :not_found
      return
    end
    # Get the chat by chat number
    chat = application.chats.find_by(number: params[:id])
    if chat.nil?
      render json: { error: "Chat not found" }, status: :not_found
      return
    end
    # Update the chat
    chat.name = params[:name]
    # transaction to update the chat
    Chat.transaction do
      @chatSave = chat.save!
    end

    if @chatSave
      # chat response is name, number
      chatResponse = {
        number: chat.number,
        name: chat.name,
      }
      render json: { chat: chatResponse, application_token: application.token }, status: :ok
    else
      render json: { error: chat.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/chats/:id/?application_token="...."
  def destroy
    # Delete a chat
    # Params:
    #   chat_number: id of the chat
    #   application_token:
    # Returns:
    #   chat: chat
    #   application_token: token of the application

    # Check if the application exists
    application = Application.find_by(token: params[:application_token])
    if application.nil?
      render json: { error: "Application not found" }, status: :not_found
      return
    end
    # Get the chat by chat number
    chat = application.chats.find_by(number: params[:id])
    if chat.nil?
      render json: { error: "Chat not found" }, status: :not_found
      return
    end
    # Delete the chat
    if chat.destroy
      # decrease the number of the chats for this application by 1
      render json: { chat: chat, application_token: application.token }, status: :ok
    else
      render json: { error: chat.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
