class EventsController < ApplicationController
  def new
    @event = Event.new
    @game_platforms = current_user.game_platforms
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    @event.save
    EventParticipation.create(event: @event, user: current_user)
    flash[:notice] = 'Seu evento foi criado'
    redirect_to @event
  end

  def show
    @event = Event.find(params[:id])
  end

  def invite
    @event = Event.find(params[:id])
    @invited_user = User.find_by(email: params[:q]) || User.find_by(nickname: params[:q])
    EventInvite.create(event: @event, user: current_user, invitee: @invited_user)
    flash[:notice] = "Convite enviado para o usuário #{@invited_user.nickname}"
    redirect_to @event
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :game_platform_id,
      :event_date, :user_limit, :event_type, :event_location)
  end
end