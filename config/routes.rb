IpnHandler::Application.routes.draw do
  match 'notify' => 'paypal_ipn#notify', :via => :post 


end
