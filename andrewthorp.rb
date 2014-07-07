require 'sinatra/base'
require 'slim'

class AndrewThorp < Sinatra::Base
  set :root,            'app'
  set :public_folder,   Proc.new { File.join(root, 'public') }
  set :views,           Proc.new { File.join(root, 'views') }

  get '/' do
    slim :index
  end

  get '/pgp' do
    slim :pgp
  end

  run! if app_file == $0
end
