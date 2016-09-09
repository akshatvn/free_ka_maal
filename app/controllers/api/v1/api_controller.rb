module Api
  module V1
    class  ApiController < ::ApplicationController

      before_filter :set_default_content_type
      before_filter :authenticate_check, except: [:utc, :ping]

      after_filter do
        Rails.logger.info "v RESPONSE ========================================"
        Rails.logger.info response.body
        Rails.logger.info "^ RESPONSE ========================================"
      end

      def ping
        render json: { auth_token: params[:auth_token], message: "Hello, creep." }
      end

      def utc
        render json: { utc: Time.zone.now.utc.strftime('%Y-%m-%dT%H:%M:%S%z') }
      end

      private

      def set_default_content_type
        response.content_type = 'application/json'
      end

      def authenticate_check
        if params[:client_id].blank? || params[:auth_token].blank?
          render json: { error: 'Incomplete authentication details.' }, status: :not_acceptable
          return false
        end

        @client = Client.where(id: params[:client_id], authentication_token: params[:auth_token]).first
        if @client.nil?
          render json: { client_id: params[:client_id], error: 'Authentication Failed.' }, status: :unauthorized
          return false
        end

        @user = @client.user
      end

    end
  end
end