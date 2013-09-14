# Public: The error routes are handled in this class.
class AndrewThorp < Sinatra::Base

  # Public: When an HTTP 403 happens, this action handles it.
  error 403 do
    haml :"errors/403", layout: true
  end

  # Public: When an HTTP 404 happens, this action handles it.
  error 404 do
    haml :"errors/404", layout: true
  end

  # Public: When an HTTP 500 happens, this action handles it.
  error 500 do
    haml :"errors/500", layout: true
  end

  # Public: A helper that lets me view the HTTP 403 page by visiting /403 in
  # the browser.
  get "/403" do
    haml :"errors/403", layout: true
  end

  # Public: A helper that lets me view the HTTP 404 page by visiting /404 in
  # the browser.
  get "/404" do
    haml :"errors/404", layout: true
  end

  # Public: A helper that lets me view the HTTP 500 page by visiting /500 in
  # the browser.
  get "/500" do
    haml :"errors/500", layout: true
  end

end
