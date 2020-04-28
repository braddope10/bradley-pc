class PokemonController < ApplicationController

    get '/pokemon' do
        
        @pokemon = Pokemon.all 
        
        erb :'pokemon/index'
    end

    get '/pokemon/new' do
        if !Helpers.logged_in?(session) 
            redirect to '/'
        end
        erb :'pokemon/new'
    end

    post '/pokemon' do
        pokemon_test = Pokemon.new(params) #.new only generates the object and doesn't save it like .create
        #BAD DATA PROTECTION
        if pokemon_test[:name].empty? || pokemon_test[:nickname].empty? || pokemon_test[:level] == nil
            redirect to '/pokemon/new'
        else
            pokemon = Pokemon.create(params)
            user = Helpers.current_user(session)
            pokemon.user = user
            pokemon.save
            redirect to "/users/#{user.id}"
        end
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