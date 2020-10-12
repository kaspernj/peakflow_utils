class NotifierErrorsController < ApplicationController
  def action_error
    raise "Test error"
  end
end
