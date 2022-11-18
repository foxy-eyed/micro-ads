# frozen_string_literal: true

Container.register_provider(:logger) do
  start do
    log_path = File.join(File.expand_path("../..", __dir__), ENV.fetch("LOGGER_PATH", "log/app.log"))
    log_level = ENV.fetch("LOGGER_LEVEL", "info")

    logger_io = ENV["APP_ENV"] == "development" ? $stdout : log_path

    logger = Ougai::Logger.new(logger_io, level: log_level)
    logger.before_log = lambda do |data|
      data[:service] = { name: ENV.fetch("APP_NAME") }
      data[:request_id] ||= Thread.current[:request_id]
    end

    register(:logger, logger)
  end
end
