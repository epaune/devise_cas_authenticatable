require 'spec_helper'

describe Devise::Strategies::CasAuthenticatable, :type => "acceptance" do
  include RSpec::Rails::RequestExampleGroup
  
  before do    
    Devise.cas_base_url = "http://www.example.com/cas_server"
    TestAdapter.reset_valid_users!

    User.delete_all
    User.create! do |u|
      u.username = "joeuser"
    end
  end
  
  after do
    visit destroy_user_session_url
  end
  
  def cas_login_url
    @cas_login_url ||= begin
      uri = URI.parse(Devise.cas_base_url + "/login")
      uri.query = Rack::Utils.build_nested_query(:service => user_service_url)
      uri.to_s
    end
  end
  
  def cas_logout_url
    @cas_logout_url ||= Devise.cas_base_url + "/logout"
  end
  
  def sign_into_cas(username, password)
    visit root_url
    current_url.should == cas_login_url
    fill_in "Username", :with => username
    fill_in "Password", :with => password
    click_on "Login"
  end
  
  describe "GET /protected/resource" do
    before { get '/' }

    it 'should redirect to sign-in' do
      response.should be_redirect
      response.should redirect_to(new_user_session_url)
    end
  end
  
  describe "GET /users/sign_in" do
    before { get new_user_session_url }
    
    it 'should redirect to CAS server' do
      response.should be_redirect
      response.should redirect_to(cas_login_url)
    end
  end
  
  it "should sign in with valid user" do
    sign_into_cas "joeuser", "joepassword"
    current_url.should == root_url
  end

  it "should fail to sign in with an invalid user" do
    sign_into_cas "invaliduser", "invalidpassword"
    current_url.should_not == root_url
  end
  
end
