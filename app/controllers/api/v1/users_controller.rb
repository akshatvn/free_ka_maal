module Api
  module V1
    class UsersController < ApiController

      before_filter :validate_user_params


      # @params
      #   - intention ['signup'/'login']
      #   - oauth_provider ['google_oauth2'/'facebook_oauth2']
      #   - user
      #     - oauth_uid
      #     - email
      #     - auth_token
      #     - expires_at
      #     - id
      #     - created_at
      #     - updated_at
      #   - client
      #     - id
      #     - auth_token
      #
      def create_oauth_user
        user = nil if @user_params[:email].blank?

        if user.present?
          if (params[:intention] == "signup")
            #"An account already exists with this Google ID. Please try again with a different one."
            render json: AppResponse.cached_find_by_code(9003), status: :precondition_failed and return
          else
            status = :ok
          end

        else
          # We don't have user now in our database.

          if params[:intention] == 'login'
            #'No account exists with this Google ID. Please try again with a different one.'
            render json: AppResponse.cached_find_by_code(9004), status: :unprocessable_entity and return
          end

          # Creating a omniauth hash. API params are not planned in a proper way. Thats why we have to do this manually on server
          # This can be created as a method as we are creating this hash in all the api controller. Not doing right now.
          # Will do once we work on api code cleanup.
          # Also a key point here is provider is not provided by some apps versions. They are in the market.
          # Nothing we can do about it. If provider is not sent by the api then system will assume its a google auth
          auth = OmniAuth::AuthHash.new(
            {
              provider: params[:oauth_provider] || 'google_oauth2',
              uid:      @user_params[:oauth_uid],
              info:
              {
                email:      @user_params[:email]
              },
              credentials:
              {
                token: @user_params[:auth_token], # OAuth 2.0 access_token, which you may wish to store
                expires_at: @user_params[:expires_at], # when the access token expires (it always will)
                expires: true # this will always be true
              }
          })
          custom_details_hash = {
            id:             @user_params[:id],
            created_at:     @user_params[:created_at],
            updated_at:     @user_params[:updated_at],
          }
          user = User.from_omniauth(auth, custom_details_hash)
          status = :created
        end

        @data, @client = user.get_response_data_for_authentication(@client_params)

        if @client.nil?
          render json: AppResponse.cached_find_by_code(9001), status: :bad_request and return
        end

        render 'api/v1/users/authenticate', :status => status
      end


      private

      def validate_user_params
        @user_params             = params[:user]
        @client_params = params[:client]

        if @user_params.blank? || @client_params.blank?
          render json: { exception: { message: t('sync.user.create.bad_request') } }, status: :not_acceptable
          return false
        end

        true
      end




    end
  end
end