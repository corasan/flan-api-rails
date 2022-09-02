module V2
    class DefaultController < ApplicationController
        def index
            render html: "Flan #{ENV['RAILS_ENV']} API V2"
        end
    end
end
