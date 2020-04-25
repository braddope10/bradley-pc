class PokemonController < ApplicationController

    get '/pokemon' do
        # current_users = Helpers.current_user(session).username
        @pokemon = Pokemon.all 
        #  @pokemon = @pok.current_users
        #  binding.pry
        erb :'pokemon/index'
    end

    get '/pokemon/new' do
        # @pokemon_name = Pokemon.find_by(name: params[:name])
        # @pokemon_nickname = Pokemon.find_by(nickname: params[:nickname])
        
        # binding.pry
        if !Helpers.logged_in?(session) 
            redirect to '/'
        # elsif @pokemon_name == "" || @pokemon_nickname == ""
            # redirect to '/'
        end
        erb :'pokemon/new'
    end

    post '/pokemon' do
        pokemon = Pokemon.create(params)
        user = Helpers.current_user(session)
        pokemon.user = user
        # if pokemon.name == "" || pokemon.nickname == ""
            # redirect to '/pokemon/new'
        # end
        pokemon.save

        redirect to "/users/#{user.id}"
    end

    get '/pokemon/:id' do
        if !Helpers.logged_in?(session)
            redirect '/'    
        end
        @pokemon = Pokemon.find_by(id:params[:id])
        if !@pokemon
            redirect to '/'
        end
        erb :'pokemon/show'
    end

    get '/pokemon/:id/edit' do
        @pokemon = Pokemon.find_by(id: params[:id])
        if !Helpers.logged_in?(session) || !@pokemon || @pokemon.user != Helpers.current_user(session)
            redirect to '/'
        end
        erb :'/pokemon/edit'
    end

    patch '/pokemon/:id' do
        pokemon = Pokemon.find_by(id: params[:id])
        if pokemon && pokemon.user == Helpers.current_user(session)
            pokemon.update(params[:pokemon])
            redirect to "/pokemon/#{pokemon.id}"
        else
            redirect to "/pokemon"
        end
    end

    delete '/pokemon/:id/delete' do
        pokemon = Pokemon.find_by(id: params[:id])
        if pokemon && pokemon.user == Helpers.current_user(session)
            pokemon.destroy
        end
        redirect to '/pokemon'
    end

end