class ProfitsController < ApplicationController
  before_action :authenticate_user!, only: :index

  authorize_resource

  def index
    @profits = current_user.profits
  end
end
