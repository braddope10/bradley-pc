require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public' #stylesheets
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "catchemall"
  end

  get "/" do
    erb :welcome
  end

end
