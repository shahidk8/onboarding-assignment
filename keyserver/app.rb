require 'json'
require './key_server'
require 'sinatra'

class KeyRoutes < Sinatra::Application
    server = KeyServerFile.new
    get '/key/generate' do
        begin 
            server.gen_keys().to_a.to_s
            status 200
        rescue ArgumentError => e
            status 400
            "Invalid Count Provided: '#{count}'"
        end 
    end
    get '/key' do
        key = server.get_available_key
        if key
            status 200
            key
        else
            status 404
            "No Key Available"
        end
    end
    patch '/key/unblock' do
        data = JSON.parse(request.body.read)
        key = data['key']
        unblocked_key = server.unblock_key(key)
        if unblocked_key
            status 200
            "#{key} unblocked"
        else
            status 400
            "Bad Request"
        end
    end
    delete '/key/:key' do |key|
        deleted_key = server.delete_key(key)
        if deleted_key
            status 200
            "#{key} deleted"
        else
            status 400
            "Bad Request"
        end
    end
    patch '/key/keep-alive' do
        data = JSON.parse(request.body.read)
        key = data['key']
        alive_key = server.keep_alive_key(key)
        if alive_key
            status 200
            "expiry increased for #{key}"
        else
            status 400
            "Bad Request"
        end
    end
    get '/*' do
        status 200
        %{Invalid Endpoint}
    end
end

KeyRoutes.run!
