require 'yaml'
require 'ghee'
require './lib/pully.rb'
require 'securerandom'


RSpec.describe "Test Library" do
  #Get github information
  def gh_info
    yaml = YAML.load_file("./spec/assets/test.yml")
    return yaml["github"]
  end

  def repo_selector
    return "#{gh_info["user"]}/#{gh_info["repo"]}"
  end

  def rand_repo_selector
    return "#{gh_info["user"]}/#{SecureRandom.hex}"
  end

  it "Fails creation with incorrect credentials" do
    expect { Pully::TestHelpers::Branch.new(user: SecureRandom.hex, pass: SecureRandom.hex, repo_selector: repo_selector, clone_url: gh_info["clone_url"]) }.to raise_error(Pully::TestHelpers::Branch::Error::BadLogin)
  end

  it "does not fail creation with incorrect credentials" do
    Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: repo_selector, clone_url: gh_info["clone_url"])
  end

  it "does fail creation with bad repo selector if passed a repo_selector without a /" do
    expect { Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: SecureRandom.hex, clone_url: gh_info["clone_url"]) }.to raise_error(Pully::TestHelpers::Branch::Error::BadRepoSelector)
  end

  it "does fail creation with unreal repository selector" do
    expect { Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: rand_repo_selector, clone_url: gh_info["clone_url"]) }.to raise_error(Pully::TestHelpers::Branch::Error::NoSuchRepository)
  end

  it "does fail creation with bad clone url" do
    expect { Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: rand_repo_selector, clone_url: "#{SecureRandom.hex}.com") }.to raise_error(Pully::TestHelpers::Branch::Error::NoSuchCloneURL)
  end

  it "Can create a new branch from our repository and delete it" do
    new_branch_name = SecureRandom.hex
    th = Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: repo_selector, clone_url: gh_info["clone_url"])

    th.create_branch(new_branch_name)
    th.commit_new_random_file(new_branch_name)

    #Make sure the branch is listed in the names
    expect(th.list_branches).to include(new_branch_name)

    #Delete the branch
    th.delete_branch(new_branch_name)
    expect(th.list_branches).not_to include(new_branch_name)
  end
end
