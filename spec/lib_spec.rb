require 'yaml'
require 'ghee'
require './lib/pully.rb'

#Get github information
def gh_info
  yaml = YAML.load_file("./spec/assets/test.yml")
  return yaml["github"]
end

RSpec.describe "Library" do
  it "Does throw an exception with INcorrect credentials while creating an object" do
    expect { pully = Pully.new(user: "abcdefgh", pass: "abcdefgh", repo: "abcdefgh") }.to raise_error(Ghee::Unauthorized)
  end

  it "Does NOT throw an exception with correct credentials while creating an object" do
    pully = Pully.new(user: gh_info["user"], pass: gh_info["pass"], repo: gh_info["repo"])
  end

  it "Can call create a new pull request and returns an integer for the pull request #" do
    #test branch creator
    new_branch_name = SecureRandom.hex
    th = Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: repo_selector, clone_url: gh_info["clone_url"])
    th.create_branch(new_branch_name)
    th.commit_new_random_file(new_branch_name)

    pully = Pully.new(user: gh_info["user"], pass: gh_info["pass"], repo: gh_info["repo"])
    n = pully.create_pull_request(from:new_branch_name, to:"master", subject:"My pull request", message:"Hey XXXX, can you merge this for me?")
    expect(n.class).to be(Fixnum)

    th.delete_branch(new_branch_name)
  end
end
