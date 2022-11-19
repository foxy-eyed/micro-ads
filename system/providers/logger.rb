# frozen_string_literal: true

Container.register_provider(:logger) do
  start do
    log_path = File.join(File.expand_path("../..", __dir__), ENV.fetch("LOGGER_PATH", "log/app.log"))
    log_level = ENV.fetch("LOGGER_LEVEL", "info")

    logger = if ENV["APP_ENV"] == "development"
               Ougai::Logger.new($stdout, level: log_level, formatter: Ougai::Formatters::Readable.new)
             else
               Ougai::Logger.new(log_path, level: log_level, formatter: Ougai::Formatters::Bunyan.new)
             end
    logger.before_log = lambda do |data|
      data[:service] = { name: ENV.fetch("APP_NAME") }
      data[:request_id] ||= Thread.current[:request_id]
    end

    register(:logger, logger)
  end
end
