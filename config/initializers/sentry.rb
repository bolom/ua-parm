Sentry.init do |config|
  config.dsn = 'https://a9535e6b8d824bf9abf87ff3e7441898@o221731.ingest.sentry.io/6741746'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end
