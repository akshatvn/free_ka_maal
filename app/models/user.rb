class User < ActiveRecord::Base

  def merge_oauth_props user_social_authorization
    self.oauth_provider = user_social_authorization.provider
    self.oauth_uid = user_social_authorization.uid
  end

  def get_response_data_for_authentication(client_params, client = nil)
    if client.nil?
      if client_params[:id].blank?
        client = clients.create(client_params)
      else
        client = clients.where(id: client_params[:id]).first
      end
    end

    if client.nil?
      return nil, nil
    else
      user = self

      # This is the default data needs to send after login.
      data = OpenStruct.new({
        auth_token: client.auth_token,
        client_id:  client.id,
        user:       user,
        counters:   counters
      })

      return data, client
    end
  end

  class << self
    def from_omniauth(auth, custom_details_hash)

      authorization = UserSocialAuthorization.
        where(provider: auth.provider,uid: auth.uid.to_s).first_or_initialize

      newly_created = false

      if authorization.user.blank?
        user =  User.where('email = ?', auth["info"]["email"]).first
        if user.blank?
          # Auth attributes
          user = User.new
          user.password = Devise.friendly_token[0, 20]
          user.first_name = auth.info.first_name
          user.last_name = auth.info.last_name
          user.email = auth.info.email
          user.login = user.email

          #Custom Attributes
          user.id = custom_details_hash.fetch(:id) { nil }
          user.created_at = custom_details_hash.fetch(:created_at) { nil }
          user.updated_at = custom_details_hash.fetch(:updated_at) { nil }
          user.promotional_coupon_code_while_registration = custom_details_hash.fetch(:code) { nil }

          user.merge_oauth_props authorization

          # Devise Overides
          user.skip_confirmation!
          # Save the object

          if user.save
            user = user.reload
          else
            logger.warn "Failed to save user"
            logger.warn user.errors.full_messages.join("\n")
          end

          newly_created = true
        end
        return user unless user.valid?

        authorization.token = auth.credentials.token
        authorization.refresh_token = auth.credentials.secret
        authorization.expires_at = Time.zone.at(auth.credentials.expires_at) unless auth.credentials.expires_at.blank?
        authorization.user_id = user.id
        authorization.save
      end

      authorization.user.newly_created = newly_created
      authorization.user
    end


  end

end