module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      if (current_user = env["warden"].user)
        current_user
      elsif (token = decoded_token)
        User.find(token[:user_id])
      else
        reject_unauthorized_connection
      end
    end

    def decoded_token
      JsonWebToken.decode(request.params[:token])
    rescue StandardError => e
      reject_unauthorized_connection
    end
  end
end
