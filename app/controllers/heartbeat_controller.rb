class HeartbeatController < ApplicationController
  def ping
    json = {
      'version_number'  => ENV['VERSION_NUMBER'] || 'Not Available',
      'build_date'      => ENV['BUILD_DATE'] || 'Not Available',
      'commit_id'       => ENV['COMMIT_ID'] || 'Not Available',
      'build_tag'       => ENV['BUILD_TAG'] || 'Not Available'
    }.to_json

    render json: json
  end

  def healthcheck
    checks = {
      database: database_connected?,
      redis: redis_connected?
    }

    status = :bad_gateway unless checks.values.all?
    render status: status, json: {
      checks: checks
    }
  end

  private

  def database_connected?
    ActiveRecord::Base.connection.active?
  rescue PG::ConnectionBad
    false
  end

  def redis_connected?
    !(!Sidekiq.redis(&:info))
  rescue Redis::CannotConnectError
    false
  end
end
