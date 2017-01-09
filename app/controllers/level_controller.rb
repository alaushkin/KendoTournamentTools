class LevelController < ApplicationController
  def findAll
    render json: Level.all
  end
end