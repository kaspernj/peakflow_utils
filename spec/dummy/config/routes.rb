Rails.application.routes.draw do
  mount PeakFlowUtils::Engine => "/peak_flow_utils"

  resources :notifier_errors, only: [] do
    post :action_error, on: :collection
  end
end
