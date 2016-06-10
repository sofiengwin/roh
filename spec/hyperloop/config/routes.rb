HyperloopApplication.routes.draw do
  get "/todos", to: "todo#index"
  get "/todo/new", to: "todo#new"
  get "/todo/create", to: "todo#create"
  get "/todo/:id/edit", to: "todo#edit"
  get "/todo/update", to: "todo#update"
  delete "/todo/:id/delete", to: "todo#index"
end
