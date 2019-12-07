class ProfitsController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
    @profits = current_user.profits
  end
end
