module AnyLogin
  module Provider
    module Devise

      module Controller

        DEFAULT_SIGN_IN = proc do |loginable|
          reset_session
          sign_in user_id.split('-').first.to_s.underscore.to_sym, loginable
        end

        def self.any_login_current_user_method
          @@any_login_current_user_method ||= "current_#{AnyLogin.klass.to_s.underscore}".to_sym
        end

        def any_login_sign_in
          params = user_id.split('-')
          @loginable = params.first.constantize.find(get_user_id)

          sign_in = DEFAULT_SIGN_IN
          instance_exec(@loginable, &sign_in)

          redirect_to main_app.send(AnyLogin.redirect_path_after_login)
        end

        def get_user_id
          if user_id.split('-').count > 2
            username = user_id.split('-').first + "-"
            uuid = user_id.gsub(username, '')
            uuid
          else
            user_id.split('-').last
          end 
        end
      end

    end
  end
end

AnyLogin.provider = AnyLogin::Provider::Devise
