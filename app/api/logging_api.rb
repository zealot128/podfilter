module LoggingApi
  extend ActiveSupport::Concern

  included do
    logger Rails.logger
    before do
      @start = Time.now.to_f
    end

    after do
      duration = (Time.now.to_f - @start) * 1000
      logger = Rails.configuration.logger
      logger ||= Rails.logger
      logger.info({
        short_message: "[#{status}] #{request.request_method} #{request.path}",
        code: status,
        ip: request.ip,
        user_agent: request.user_agent,
        params: request.params.except('route_info').to_hash,
        duration: duration.to_i,
        session: request.session.to_hash.except('session_id', '_csrf_token').to_hash
      })
    end
    rescue_from ArgumentError, NotImplementedError
    rescue_from :all do |e|
      if Rails.env.test?
        raise e
      end
      trace = e.backtrace.grep(/podfilter/)
      Rails.logger.error "#{e.message}\n\n#{trace.join("\n")}"
      ExceptionNotifier.notify_exception(e) if Rails.env.production?
      Rack::Response.new({ message: e.message, backtrace: trace }.to_json, 500, { 'Content-type' => 'application/json' }).finish
    end

  end
end
