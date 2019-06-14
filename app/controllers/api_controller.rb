class ApiController < ApplicationController
  skip_before_action :set_locale
  before_action :set_defaults, :set_language, :track_request

  SUPPORTED_LOCALES = %w(en de fr ja).freeze
  GA_URL = 'www.google-analytics.com/collect'.freeze
  GA_TID = Rails.application.credentials.dig(:google_analytics, :tracking_id).freeze

  def render_not_found
    render json: { status: 404, error: 'Not found' }, status: :not_found
  end

  private
  def sanitize_query_params
    query = params.except(:format, :controller, :action)
    query.each do |k, v|
      if k =~ /_in\Z/
        case v
        when /,/
          query[k] = v.split(/,\s?/)
        when /\b\.{3}\b/
          query[k] = Range.new(*v.scan(/\d+/), exclusive: true)
        when /\b\.{2}\b/
          query[k] = Range.new(*v.scan(/\d+/))
        end
      end
    end
  end

  def set_defaults
    request.format = :json unless params[:format]

    if params[:action] == 'index'
      params[:limit] ||= 10
      @query = sanitize_query_params
    end
  end

  def set_language
    language = params[:language]

    if language.present? && SUPPORTED_LOCALES.include?(language)
      I18n.locale = language
    end
  end

  def track_request
    if Rails.env.production? && GA_TID.present?
      RestClient.post(GA_URL, { v: 1, tid: GA_TID, cid: Digest::MD5.hexdigest(request.remote_ip),
                                t: 'pageview', dp: request.fullpath })
    end
  end
end
