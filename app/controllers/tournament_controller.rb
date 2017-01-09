class TournamentController < ApplicationController
  def page
    p = Tournament.paginate(:page => params[:num], :per_page => params[:per_page])
    render json: {:current_page => p.current_page,
                  :per_page => p.per_page,
                  :total_entries => p.total_entries,
                  :entries => p}
  end

  def details
    t = Tournament.find(params[:id])
    render json: t.to_json(:include => [:status, :tournament_type])
  end

  def save
    t = Tournament.new(tournament_params)
    r = t.save
    if r == true
      render json: {:id => t.id}
    else
      render json: {:error => t.errors.full_messages}
    end
  end

  def update
    t = Tournament.find(tournament_params[:id])
    r = t.update tournament_params
    if r == true
      render json: {:id => t.id}
    else
      render json: {:error => t.errors.full_messages}
    end
  end

  def tournament_params
    params.require(:tournament).permit(:id, :full_name, :short_name, :status_id, :tournament_type_id, :end_date, :start_date)
  end
end