class RewardsController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
    @profit = current_user.profits
  end
end
