PeakFlowUtils::Engine.routes.draw do
  namespace :pings do
    get "postgres_connections", to: "postgres_connections#count"
    get "sidekiq", to: "sidekiq#index"
  end
end
