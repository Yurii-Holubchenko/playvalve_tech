module V1
  class CheckStatusController < ApplicationController
    def create
      user = User.find_by(idfa: permitted_params[:idfa])

      if user.not_banned?
        # TODO: Add check for device
      end
    end

    private

    def permitted_params
      params.permit(:idfa, :rooted_device)
    end
  end
end
