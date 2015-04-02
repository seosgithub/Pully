require 'yaml'
require 'ghee'
require './lib/pully.rb'

#Get github information
def gh_info
  yaml = YAML.load_file("./spec/assets/test.yml")
  return yaml["github"]
end

RSpec.describe "Library" do
  def repo_selector(user:, repo:, owner:)
    return "#{user}/#{repo}" unless owner
    return "#{owner}/#{repo}"
  end

  it "Does throw an exception with INcorrect credentials while creating an object" do
    expect { pully = Pully.new(user: "abcdefgh", pass: "abcdefgh", repo: "abcdefgh") }.to raise_error(Pully::Pully::Error::BadLogin)
  end

  it "Does NOT throw an exception with correct credentials while creating an object" do
    pully = Pully.new(user: gh_info["user"], pass: gh_info["pass"], repo: gh_info["repo"])
  end

  it "DOES throw an exception with correct credentials while creating an object but with a non-existant repository" do
    expect { pully = Pully.new(user: gh_info["user"], pass: gh_info["pass"], repo: SecureRandom.hex) }.to raise_error(Pully::Pully::Error::NonExistantRepository)
  end

  it "Does throw an exception with correct credentials while creating an object with an alternate owner but without specifying that owner" do
    expect { pully = Pully.new(user: gh_info["user"], pass: gh_info["pass"], repo: gh_info["org_repo"])}.to raise_error
  end

 it "Can call create a new pull request and returns an integer for the pull request #" do
    sleep 10
    #test branch creator
    new_branch_name = SecureRandom.hex
    th = Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: repo_selector(user: gh_info["user"], repo: gh_info["repo"], owner:nil), clone_url: gh_info["clone_url"])
    th.create_branch(new_branch_name)
    th.commit_new_random_file(new_branch_name)

    pully = Pully.new(user: gh_info["user"], pass: gh_info["pass"], repo: gh_info["repo"])
    n = pully.create_pull_request(from:new_branch_name, to:"master", subject:"My pull request", message:"Hey XXXX, can you merge this for me?")
    expect(n.class).to be(Fixnum)

    th.delete_branch(new_branch_name)
  end

  it "Can call create a new pull request for an organization repo and returns an integer for the pull request #" do
    sleep 10
    #test branch creator
    new_branch_name = SecureRandom.hex
    th = Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: repo_selector(user: gh_info["user"], repo: gh_info["org_repo"], owner:gh_info["org_owner"]), clone_url: gh_info["org_clone_url"])
    th.create_branch(new_branch_name)
    th.commit_new_random_file(new_branch_name)

    pully = Pully.new(user: gh_info["user"], pass: gh_info["pass"], repo: gh_info["org_repo"], owner: gh_info["org_owner"])
    n = pully.create_pull_request(from:new_branch_name, to:"master", subject:"My pull request", message:"Hey XXXX, can you merge this for me?")
    expect(n.class).to be(Fixnum)

    th.delete_branch(new_branch_name)
  end

  it "Can call create a new pull request and write a comment on that pull request" do
    #test branch creator
    new_branch_name = SecureRandom.hex
    th = Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: repo_selector(user: gh_info["user"], repo: gh_info["repo"], owner:nil), clone_url: gh_info["clone_url"])
    th.create_branch(new_branch_name)
    th.commit_new_random_file(new_branch_name)

    pully = Pully.new(user: gh_info["user"], pass: gh_info["pass"], repo: gh_info["repo"])
    pull_number = pully.create_pull_request(from:new_branch_name, to:"master", subject:"My pull request", message:"Hey XXXX, can you merge this for me?")

    before_create = pully.comments_for_pull_request(pull_number).length
    pully.write_comment_to_pull_request(pull_number, "Test Comment")
    after_create = pully.comments_for_pull_request(pull_number).length

    expect(after_create).to eq(before_create+1)

    th.delete_branch(new_branch_name)
  end

  it "Can call create a new pull request and write a comment on that pull request for an organization" do
    #test branch creator
    new_branch_name = SecureRandom.hex
    th = Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: repo_selector(user: gh_info["user"], repo: gh_info["org_repo"], owner:gh_info["org_owner"]), clone_url: gh_info["org_clone_url"])
    th.create_branch(new_branch_name)
    th.commit_new_random_file(new_branch_name)

    pully = Pully.new(user: gh_info["user"], pass: gh_info["pass"], repo: gh_info["org_repo"], owner: gh_info["org_owner"])
    pull_number = pully.create_pull_request(from:new_branch_name, to:"master", subject:"My pull request", message:"Hey XXXX, can you merge this for me?")

    before_create = pully.comments_for_pull_request(pull_number).length
    pully.write_comment_to_pull_request(pull_number, "Test Comment")
    after_create = pully.comments_for_pull_request(pull_number).length

    expect(after_create).to eq(before_create+1)

    th.delete_branch(new_branch_name)
  end

  it "Can call create a new pull request, get the SHA of that pull request, and compare it to the SHA of the from branch" do
    sleep 10
    #test branch creator
    new_branch_name = SecureRandom.hex
    th = Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: repo_selector(user: gh_info["user"], repo: gh_info["repo"], owner:nil), clone_url: gh_info["clone_url"])
    th.create_branch(new_branch_name)
    local_sha = th.commit_new_random_file(new_branch_name)

    pully = Pully.new(user: gh_info["user"], pass: gh_info["pass"], repo: gh_info["repo"])
    pull_number = pully.create_pull_request(from:new_branch_name, to:"master", subject:"My pull request", message:"Hey XXXX, can you merge this for me?")

    from_sha = pully.sha_for_pull_request(pull_number)

    expect(local_sha).to eq(from_sha)

    th.delete_branch(new_branch_name)
  end

  it "Changes the SHA when commits are added after a pull request" do
    sleep 10
    #test branch creator
    new_branch_name = SecureRandom.hex
    th = Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: repo_selector(user: gh_info["user"], repo: gh_info["repo"], owner:nil), clone_url: gh_info["clone_url"])
    th.create_branch(new_branch_name)
    local_sha_a = th.commit_new_random_file(new_branch_name)

    pully = Pully.new(user: gh_info["user"], pass: gh_info["pass"], repo: gh_info["repo"])
    pull_number = pully.create_pull_request(from:new_branch_name, to:"master", subject:"My pull request", message:"Hey XXXX, can you merge this for me?")

    #Get the SHA from the pull request
    from_sha_a = pully.sha_for_pull_request(pull_number)
    expect(local_sha_a).to eq(from_sha_a)

    local_sha_b = th.commit_new_random_file(new_branch_name)
    sleep 5 #Wait for GitHub to update
    from_sha_b = pully.sha_for_pull_request(pull_number)
    expect(local_sha_b).not_to eq(local_sha_a)
    expect(local_sha_b).to eq(from_sha_b)

    th.delete_branch(new_branch_name)
  end

  it "Can set the pull request status to success, assumes BUG IN GITHUB SETS TO PENDING" do
    sleep 10
    #test branch creator
    new_branch_name = SecureRandom.hex
    th = Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: repo_selector(user: gh_info["user"], repo: gh_info["repo"], owner:nil), clone_url: gh_info["clone_url"])
    th.create_branch(new_branch_name)
    th.commit_new_random_file(new_branch_name)

    pully = Pully.new(user: gh_info["user"], pass: gh_info["pass"], repo: gh_info["repo"])
    pull_number = pully.create_pull_request(from:new_branch_name, to:"master", subject:"My pull request", message:"Hey XXXX, can you merge this for me?")
    pully.sha_for_pull_request(pull_number) 

    status = pully.pull_request_status(pull_number)
    expect(status).to eq("pending")

    pully.set_pull_request_status(pull_number, "success")
    status = pully.pull_request_status(pull_number)
    expect(status).to eq("success") 

    th.delete_branch(new_branch_name)
  end

  it "Can get the from and to names of the pull request" do
    sleep 10
    #test branch creator
    new_branch_name = SecureRandom.hex
    th = Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: repo_selector(user: gh_info["user"], repo: gh_info["repo"], owner:nil), clone_url: gh_info["clone_url"])
    th.create_branch(new_branch_name)
    th.commit_new_random_file(new_branch_name)

    pully = Pully.new(user: gh_info["user"], pass: gh_info["pass"], repo: gh_info["repo"])
    pull_number = pully.create_pull_request(from:new_branch_name, to:"master", subject:"My pull request", message:"Hey XXXX, can you merge this for me?")
    branches = pully.pull_request_branches(pull_number) 

    expect(branches[:from]).to eq(new_branch_name)
    expect(branches[:to]).to eq("master")

    th.delete_branch(new_branch_name)
  end

  it "Can get the from and to names of the pull request from an organization" do
    sleep 10
    #test branch creator
    new_branch_name = SecureRandom.hex
    th = Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: repo_selector(user: gh_info["user"], repo: gh_info["org_repo"], owner:gh_info["org_owner"]), clone_url: gh_info["org_clone_url"])
    th.create_branch(new_branch_name)
    th.commit_new_random_file(new_branch_name)

    pully = Pully.new(user: gh_info["user"], pass: gh_info["pass"], repo: gh_info["org_repo"], owner: gh_info["org_owner"])
    pull_number = pully.create_pull_request(from:new_branch_name, to:"master", subject:"My pull request", message:"Hey XXXX, can you merge this for me?")
    branches = pully.pull_request_branches(pull_number) 

    expect(branches[:from]).to eq(new_branch_name)
    expect(branches[:to]).to eq("master")

    th.delete_branch(new_branch_name)
  end

  it "Can merge the pull request into master" do
    sleep 10
    #test branch creator
    new_branch_name = SecureRandom.hex
    th = Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: repo_selector(user: gh_info["user"], repo: gh_info["repo"], owner:nil), clone_url: gh_info["clone_url"])
    th.create_branch(new_branch_name)
    last_sha = th.commit_new_random_file(new_branch_name)

    pully = Pully.new(user: gh_info["user"], pass: gh_info["pass"], repo: gh_info["repo"])
    pull_number = pully.create_pull_request(from:new_branch_name, to:"master", subject:"My pull request", message:"Hey XXXX, can you merge this for me?")
    msg = SecureRandom.hex
    pully.merge_pull_request(pull_number, msg)

    #Commit message contains message given
    th = Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: repo_selector(user: gh_info["user"], repo: gh_info["repo"], owner:nil), clone_url: gh_info["clone_url"])
    expect(th.latest_message("master") =~ /#{msg}/).not_to eq(nil)

    #We expect the pull request to be closed
    expect(pully.pull_request_is_open?(pull_number)).to eq(false)

    th.delete_branch(new_branch_name)
  end

  it "Can list pull requests" do
    sleep 10
    #test branch creator
    new_branch_name = SecureRandom.hex
    th = Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: repo_selector(user: gh_info["user"], repo: gh_info["repo"], owner:nil), clone_url: gh_info["clone_url"])
    th.create_branch(new_branch_name)
    last_sha = th.commit_new_random_file(new_branch_name)

    pully = Pully.new(user: gh_info["user"], pass: gh_info["pass"], repo: gh_info["repo"])
    pull_number = pully.create_pull_request(from:new_branch_name, to:"master", subject:"My pull request", message:"Hey XXXX, can you merge this for me?")

    expect(pully.pull_requests).to include(pull_number)

    th.delete_branch(new_branch_name)

  end

  it "Can list all success and pending pull requests" do
    sleep 10
    new_branch_name = SecureRandom.hex
    new_branch_name2 = SecureRandom.hex
    th = Pully::TestHelpers::Branch.new(user: gh_info["user"], pass: gh_info["pass"], repo_selector: repo_selector(user: gh_info["user"], repo: gh_info["repo"], owner:nil), clone_url: gh_info["clone_url"])
    th.create_branch(new_branch_name)
    th.commit_new_random_file(new_branch_name)

    th.create_branch(new_branch_name2)
    th.commit_new_random_file(new_branch_name2)

    pully = Pully.new(user: gh_info["user"], pass: gh_info["pass"], repo: gh_info["repo"])
    pull_number = pully.create_pull_request(from:new_branch_name, to:"master", subject:"My pull request", message:"Hey XXXX, can you merge this for me?")
    pull_number2 = pully.create_pull_request(from:new_branch_name2, to:"master", subject:"My pull request", message:"Hey XXXX, can you merge this for me?")
    pully.set_pull_request_status(pull_number, 'error')

    expect(pully.open_or_pending_pull_requests).not_to include(pull_number)
    expect(pully.open_or_pending_pull_requests).to include(pull_number2)

    th.delete_branch(new_branch_name)

  end
end
