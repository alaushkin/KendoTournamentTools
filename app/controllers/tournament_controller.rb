class TournamentController < ApplicationController
  ## Views
  def page_view
    filter = {}
    if !params[:status_id].nil?
      filter[:status_id] = params[:status_id]
    end
    if !params[:tournament_type_id].nil?
      filter[:tournament_type_id] = params[:tournament_type_id]
    end
    @page = Tournament.where(filter).order("start_date desc")
            .paginate(:page => params[:num], :per_page => params[:per_page])
    render 'tournaments/page.html.erb'
  end

  def details_view
    @tournament = Tournament.find(params[:id])
    @persons_count = TournamentPerson.where(:tournament_id => @tournament.id).count
    render 'tournaments/details.html.erb'
  end

  def new_view
    if !check_user
      return
    end
    render 'tournaments/new.html.erb'
  end

  def edit_view
    if !check_user
      return
    end
    @tournament = Tournament.find(params[:id])
    render 'tournaments/edit.html.erb'
  end

  ## API

  def page
    filter = {}
    if !params[:status_id].nil?
      filter[:status_id] = params[:status_id]
    end
    if !params[:tournament_type_id].nil?
      filter[:tournament_type_id] = params[:tournament_type_id]
    end
    p = Tournament.where(filter).order("start_date desc")
            .paginate(:page => params[:num], :per_page => params[:per_page])
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
    if !check_user
      return
    end
    t = Tournament.new(tournament_params)
    r = t.save
    if r == true
      redirect_to '/views/tournament/'+t.id.to_s
    else
      render json: {:error => t.errors.full_messages}
    end
  end

  def update
    if !check_user
      return
    end
    t = Tournament.find(tournament_params[:id])
    r = t.update tournament_params
    if r == true
      redirect_to '/views/tournament/'+t.id.to_s
    else
      render json: {:error => t.errors.full_messages}
    end
  end

  def tournament_params
    params.require(:tournament).permit(:id, :full_name, :short_name, :status_id, :tournament_type_id, :end_date, :start_date, :place)
  end
end