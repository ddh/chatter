OpenAI.configure do |config|
  config.access_token = ENV.fetch("AZURE_OPENAI_API_KEY")
  config.uri_base = ENV.fetch("AZURE_OPENAI_URI")

  config.api_type = :azure
  config.api_version = "2023-03-15-preview"
end
