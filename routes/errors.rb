class AndrewThorp < Sinatra::Base

  error 403 do
    haml :"errors/403", layout: true
  end

  error 404 do
    haml :"errors/404", layout: true
  end

  error 500 do
    haml :"errors/500", layout: true
  end

  get "/403" do
    haml :"errors/403", layout: true
  end

  get "/404" do
    haml :"errors/404", layout: true
  end

  get "/500" do
    haml :"errors/500", layout: true
  end

end
