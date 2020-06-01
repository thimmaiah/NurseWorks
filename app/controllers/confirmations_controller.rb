class ConfirmationsController < DeviseTokenAuth::ConfirmationsController

	def show
      @resource = resource_class.confirm_by_token(resource_params[:confirmation_token])

      Rails.logger.debug @resource.errors.messages[:email]

      # We had to do this as users were getting errors if they clicked on the confirm link twice.
      if @resource.errors.empty? || 
      	(@resource.errors.messages[:email].present? &&  @resource.errors.messages[:email][0] == "was already confirmed, please try signing in")

        yield @resource if block_given?

        redirect_header_options = { account_confirmation_success: true }

        if signed_in?(resource_name)
          token = signed_in_resource.create_token

          redirect_headers = build_redirect_headers(token.token,
                                                    token.client,
                                                    redirect_header_options)

          redirect_to_link = signed_in_resource.build_auth_url(redirect_url, redirect_headers)
        else
          redirect_to_link = DeviseTokenAuth::Url.generate(redirect_url, redirect_header_options)
       end

        redirect_to(redirect_to_link)
      else
        raise ActionController::RoutingError, 'Not Found'
      end
    end

end