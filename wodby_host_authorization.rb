# frozen_string_literal: true

require "json"

wodby_hosts = JSON.parse(ENV.fetch("WODBY_HOSTS", "[]"))
wodby_service_host = ENV["WODBY_APP_SERVICE_NAME"]
wodby_hosts << wodby_service_host if wodby_service_host && !wodby_hosts.include?(wodby_service_host)

# Wodby route hosts and the internal service hostname are trusted explicitly.
# Health probes do not carry a public Host header, so keep that endpoint out of
# host authorization.
unless wodby_hosts.empty?
  Rails.application.config.hosts.concat(wodby_hosts).uniq!
  Rails.application.config.host_authorization = {
    exclude: ->(request) { request.path == "/healthz" }
  }
end
