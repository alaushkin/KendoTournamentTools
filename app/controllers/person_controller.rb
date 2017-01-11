class PersonController < ApplicationController
  def findAll
    render json: Person.all
  end

  def details
    record = Person.find(params[:id])
    render json: record.to_json(:include => [:level, :club])
  end

  def save
    record = Person.new(person_params)
    r = record.save
    if r == true
      render json: {:id => record.id}
    else
      render json: {:error => record.errors.full_messages}
    end
  end

  def update
    record = Person.find(person_params[:id])
    r = t.update person_params
    if r == true
      render json: {:id => record.id}
    else
      render json: {:error => record.errors.full_messages}
    end
  end

  def check
    if !user_signed_in?
      render json: "FUCKUP"
      return
    end
    render json: current_user
  end

  def person_params
    params.require(:person).permit(:id, :rank, :sex, :first_name, :last_name, :middle_name, :club_id, :level_id, :birth_date, :phone, :email)
  end
end