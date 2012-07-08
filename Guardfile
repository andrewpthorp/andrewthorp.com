require './public/stylesheets/sass/bourbon/lib/bourbon'

guard 'coffeescript', :input => 'public/javascripts/coffee', :output => 'public/javascripts'
guard 'sass', :input => 'public/stylesheets/sass', :output => 'public/stylesheets'

guard 'livereload' do
  watch(%r{public/stylesheets/.+\.css})
  watch(%r{.+\.html})
end
