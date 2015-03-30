require 'yaml'
require 'ghee'

RSpec.describe "Unit test authentication" do
  it "Does authenticate with unit test account" do
    yaml = YAML.load_file("./spec/test.yml")
    user = yaml["github"]["user"]
    pass = yaml["github"]["pass"]

    gh = Ghee.basic_auth(user, pass)
    gh.repos(user, "").to_s

    #Will throw exception on authentication error
    
  end
end
