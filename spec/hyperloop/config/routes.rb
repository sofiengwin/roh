HyperloopApplication.routes.draw do
  get "/todos", to: "todo#index"
  get "/todo/new", to: "todo#new"
  get "/todo/:id/edit", to: "todo#index"
  delete "/todo/:id/delete", to: "todo#index"
end
