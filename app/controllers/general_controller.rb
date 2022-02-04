class GeneralController < ApplicationController
  skip_before_action :authenticate_user

  def index
    render html: 'Flan API'
  end
end
