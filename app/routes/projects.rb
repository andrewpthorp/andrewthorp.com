class AndrewThorp < Sinatra::Base

  get '/projects' do
    @projects = Project.published
    haml :'projects/index'
  end

  get '/projects/new' do
    protected!
    @project = Project.new
    haml :'projects/new', layout: true
  end

  post '/projects' do
    protected!
    @project = Project.new(params[:project])
    if @project.save
      redirect '/projects'
    else
      haml :'projects/new', layout: true
    end
  end

  get '/projects/:id/edit' do
    protected!
    @project = Project.first(id: params[:id])
    haml :'projects/edit', layout: true
  end

  put '/projects/:id' do
    protected!
    @project = Project.first(id: params[:id])
    if @project.update(params[:project])
      redirect '/projects'
    else
      haml :'projects/edit', layout: true
    end
  end

  get '/projects/:id/delete' do
    protected!
    @project = Project.first(id: params[:id])
    @project.destroy
    redirect '/projects'
  end

end
