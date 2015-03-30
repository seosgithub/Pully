require 'yaml'
require 'ghee'
require './lib/pully.rb'

RSpec.describe "Test Library" do
  it "Does throw an exception with INcorrect credentials while creating an object" do
    expect { pully = Pully.new(user: "abcdefgh", pass: "abcdefgh", repo: "abcdefgh") }.to raise_error(Ghee::Unauthorized)
  end

  it "Does NOT throw an exception with correct credentials while creating an object" do
    yaml = YAML.load_file("./spec/test.yml")
    user = yaml["github"]["user"]
    pass = yaml["github"]["pass"]
    repo = yaml["github"]["repo"]

    pully = Pully.new(user: user, pass: pass, repo: repo)
    #No exception
  end

  #it "Can call create a new pull request and returns the pull number" do
    #yaml = YAML.load_file("./spec/test.yml")
    #user = yaml["github"]["user"]
    #pass = yaml["github"]["pass"]
    #repo = yaml["github"]["repo"]

    #pully = Pully.new(user: user, pass: pass, repo: repo)
    #n = pully.create_pull_request(from:"my_branch", to:"master", subject:"My pull request", message:"Hey XXXX, can you merge this for me?")
    #puts n
    #expect(n.class).to be(Integer)
    ##No exception
  #end
end
