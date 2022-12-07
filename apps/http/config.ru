# frozen_string_literal: true

require_relative "../../config/environment"
require_relative "../../config/boot"

use Rack::RequestId
use Rack::Ougai::LogRequests, Container["logger"]

use Rack::Reloader if ENV["APP_ENV"] == "development"

run Container["http.app"]
