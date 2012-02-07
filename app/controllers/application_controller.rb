class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
  	@getters = getters
  end

  private

  def getters
    ['pug','placeholder','kitten','zombie', 'babe', 'falukorv']
  end
end
