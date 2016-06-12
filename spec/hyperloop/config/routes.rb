HyperloopApplication.routes.draw do
  delete "/todo/:id/destroy", to: "todo#destroy"
  get "/todo/index", to: "todo#index"
  get "/todo/new", to: "todo#new"
  post "/todo/create", to: "todo#create"
  get "/todo/:id/show", to: "todo#show"
  get "/todo/:id/edit", to: "todo#edit"
  put "/todo/update", to: "todo#update"
end
