class GeneralController < ApplicationController
  skip_before_action :authenticate_user
  skip_before_action :auth_payload

  def index
    render html: 'Flan API'
  end
end
