class ConvertedController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
  end

  def create
    @comments_from_form = params['sqltoconvert']
    #do your stuff with comments_from_form here
    @bite = Converter.new(@comments_from_form)
    @chatte = @bite.convert_output
    #render inline: "<% @chatte.each do |bite| %><%= bite %></br><% end %>"
    render :index
  end
end
