class ConvertedController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
  end

  def create
    sql = params['sqltoconvert']
    @to_convert = Converter.new(sql)
    @converted_file = @to_convert.convert_output
    render :index
  end
end
