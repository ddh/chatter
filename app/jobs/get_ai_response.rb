class GetAiResponse
  include Sidekiq::Worker
  def perform(chat_id)
    chat = Chat.find(chat_id)
    call_openai(chat: chat)
  end

  private

  def call_openai(chat:)
    message = chat.messages.create(role: "assistant", content: "")
    message.broadcast_created

    # Chat
    OpenAI::Client.new.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: Message.for_openai(chat.messages.reload),
        temperature: 0,
        stream: proc do |chunk, _bytesize|
          new_content = chunk.dig("choices", 0, "delta", "content")
          message.update(content: message.content + new_content) if new_content
        end
      }
    )


    # Completions
    # OpenAI::Client.new.completions(
    #   parameters: {
    #     model: "text-davinci-001",
    #     prompt: "Once upon a time",
    #     max_tokens: 5
    #   }
    # )
  end
end
