require 'rack-flash'
class EventsController < ApplicationController
  use Rack::Flash

  get '/events' do
    if session[:user_id]
      @events = Event.all
      @comments = Comment.all
      @user = User.find_by_id(session[:user_id])
  #
  #     @event = Event.create(:title => params[:title], :date => params[:date], :volunteers_needed => params[:volunteers_needed], :description => params[:description], :user_id => @user.id, :comment_id => @comment.id)
  # @comment = Comment.create(:content => params[:content], :user_id => @user.id, :event_id => @event.id)
      erb :'events/home'
    else
      redirect to 'users/login'
    end
  end

  get '/events/new' do
    if session[:user_id]
      erb :"/events/new"
    else
      redirect to 'users/login'
    end
  end

  post '/events' do
    if params[:title] == "" || params[:date] == "" || params[:volunteers_needed] == "" || params[:description] == ""
        flash[:message] = "Please try again. All field must be filled in."
      redirect to "/events/new"
    else
      @user = User.find_by_id(session[:user_id])
      @event = Event.create(:title => params[:title], :date => params[:date], :volunteers_needed => params[:volunteers_needed], :description => params[:description], :user_id => @user.id, :comment_id => @comment.id)

       @comment = Comment.create(:content => params[:content], :event_id => @event.id, :user_id => @user.id)
      redirect to "/events/#{@event.id}"
    end
  end


  get '/events/:id' do
   if session[:user_id]
      @event = Event.find_by_id(params[:id])
      @comment = Comment.find_by_id(params[:event_id])

      erb :'events/show'
    else
      redirect to '/login'
    end
  end


  get '/events/:id/edit' do
    if session[:user_id]
      @event = Event.find_by_id(params[:comment_id])
     @comment = Comment.find_by(:content => params[:content], :event_id => @event.id, :user_id => @user.id)

        erb :'events/edit'
  else
      redirect to '/login'
    end
  end

patch '/events/:id' do
    if params[:title] == "" || params[:date] == "" || params[:volunteers_needed] == "" || params[:description] == "" || Event.find_by_id(params[:id]) == nil
      flash[:message] = "Edit was unsuccessful. Please try again."
      redirect to "/users/show"

    else

       @user = User.find_by_id(session[:user_id])
      @event = Event.find_by_id(params[:id])

      @event.title = params[:title]
      @event.date = params[:date]
      @event.volunteers_needed = params[:volunteers_needed]
      @event.description = params[:description]

      # @comment = Comment.find_by_id(params[:event_id])
  @comment = Comment.create(:content => params[:content], :event_id => @event.id, :user_id => @user.id)
        @comment.content = params[:content]
            @event.comment_id = @comment.id
# @comment.user_id == @user.id
# @event.comment_id == @comment.id
# @comment.event_id == @event.id
       binding.pry
      #  @comment.user_id == session[:user_id]
      # @comment.save
      @event.save
      flash[:message] = "You have successfully updated event."
      redirect to "/events/#{@event.id}"
    end
  end

  delete '/events/:id/delete' do
    if session[:user_id]
      @event = Event.find_by_id(params[:id])
       if @user_id == session[:user_id] && @event_id == @event.id
        @event.delete
        flash[:message] = "You have successfully deleted event."
        redirect to '/events'
      else
        redirect to '/events'
      end
    else
      redirect to '/login'
    end
  end
 end
