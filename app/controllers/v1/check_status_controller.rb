module V1
  class CheckStatusController < ApplicationController
    def create
      user = UserCheck.new(
        permitted_params[:idfa],
        permitted_params[:rooted_device],
        user_country,
        user_ip
      ).call

      render json: user.slice(:ban_status)
    end

    private

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
