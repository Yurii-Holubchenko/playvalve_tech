module V1
  class CheckStatusController < ApplicationController
    def create
      user = User.find_or_create_by(idfa: permitted_params[:idfa])

      unless user.banned?
        # TODO: Add check for device
      end

      render json: user.slice(:ban_status)
    end

    private

    def permitted_params
      params.permit(:idfa, :rooted_device)
    end
  end
end
