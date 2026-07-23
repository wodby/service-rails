# frozen_string_literal: true

require "json"

wodby_hosts = JSON.parse(ENV.fetch("WODBY_HOSTS", "[]"))

# An empty host list disables Rails host authorization outside development by
# default. Preserve that behavior while extending any active allowlist.
unless Rails.application.config.hosts.empty?
  Rails.application.config.hosts.concat(wodby_hosts).uniq!
end
