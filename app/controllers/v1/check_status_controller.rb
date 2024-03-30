module V1
  class CheckStatusController < ApplicationController
    def create
      user = User.find_by(idfa: permitted_params[:idfa])

      unless user.present? && user.banned?
        valid_device = device_status.valid?
        user = User.find_or_create_by(idfa: permitted_params[:idfa])

        unless valid_device
          user.update(ban_status: User::BANNED)
        end
      end

      render json: user.slice(:ban_status)
    end

    private

    def device_status
      @device_status ||=::DeviceStatusCheck.new(
        permitted_params[:idfa],
        user_country,
        permitted_params[:rooted_device],
        user_ip
      )
    end

    def user_country
      request.env["HTTP_CF_IPCOUNTRY"]
    end

    def user_ip
      if Rails.env.production?
        request.remote_ip
      else
        Faraday.get("http://checkip.amazonaws.com/").body.strip
      end
    end

    def permitted_params
      params.permit(:idfa, :rooted_device)
    end
  end
end
