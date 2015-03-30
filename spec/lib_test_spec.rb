require 'yaml'
require 'ghee'
require './lib/pully.rb'
require 'securerandom'

#Get github information
def gh_info
  yaml = YAML.load_file("./spec/test.yml")
  return yaml["github"]
end

def repo_selector
  return "#{gh_info["user"]}/#{gh_info["repo"]}"
end

def rand_repo_selector
  return "#{gh_info["user"]}/#{SecureRandom.hex}"
end

RSpec.describe "Test Library" do
  it "Fails creation with incorrect credentials" do
    expect { Pully::TestHelpers::Branch.new(user: SecureRandom.hex, pass: SecureRandom.hex, repo_selector: repo_selector) }.to raise_error(Octokit::Unauthorized)
  end

  it "does not fail creation with incorrect credentials" do
    Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: repo_selector)
  end

  it "does fail creation with bad repo selector if passed a repo_selector without a /" do
    expect { Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: SecureRandom.hex) }.to raise_error(Pully::TestHelpers::Branch::Error::BadRepoSelector)
  end

  it "does fail creation with non-existant repository" do
    expect { Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: rand_repo_selector) }.to raise_error(Pully::TestHelpers::Branch::Error::NoSuchRepository)
  end
end
