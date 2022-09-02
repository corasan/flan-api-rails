module V2
    class DefaultController < ApplicationController
        skip_before_action :authenticate_user

        def index
            render html: "Flan #{ENV['RAILS_ENV']} API V2"
        end
    end
end
