require 'spec_helper'

describe PaypalIpnControllerController do

  describe "GET 'notify'" do
    it "returns http success" do
      get 'notify'
      response.should be_success
    end
  end

end
