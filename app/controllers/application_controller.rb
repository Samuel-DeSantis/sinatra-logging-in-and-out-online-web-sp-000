require_relative '../../config/environment'
class ApplicationController < Sinatra::Base
  configure do
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  post '/login' do
    @user = User.find_by(username: params[:username]) #=> Finding user by username
    if @user != nil && @user == params[:password] #=> Making sure there is a user
      session[:user_id] = @user.id                #   and that the passwords match
      redirect '/account'                         #   if correct, route to account
    end
    redirect '/error' #=> if passwords don't match, then path to error
  end

  get '/account' do
    @current_user = User.find_by_id(session[:user_id])
    if @current_user
      erb :account
    else
      erb :error
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end


end

