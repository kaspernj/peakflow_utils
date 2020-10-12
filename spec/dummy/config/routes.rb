Rails.application.routes.draw do
  mount PeakFlowUtils::Engine => "/peak_flow_utils"

  resources :notifier_errors, only: [] do
    collection do
      post :action_error
    end
  end
end
