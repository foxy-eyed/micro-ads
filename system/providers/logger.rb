# frozen_string_literal: true

Container.register_provider(:logger) do
  start do
    log_path = File.join(File.expand_path("../..", __dir__), ENV.fetch("LOGGER_PATH", "log/app.log"))
    log_level = ENV.fetch("LOGGER_LEVEL", "info")

    logger_io = ENV["APP_ENV"] == "production" ? log_path : $stdout

    logger = Ougai::Logger.new(logger_io, level: log_level)
    logger.before_log = lambda do |data|
      data[:service] = { name: ENV.fetch("APP_NAME", "ads") }
    end

    register(:logger, logger)
  end
end
