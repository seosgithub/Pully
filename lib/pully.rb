require "pully/version"
require 'ghee'
require 'octokit'
require 'git'
require 'tempfile'

module Pully
  class Pully
    def initialize(user:, pass:, repo:)
      @user = user
      @repo = repo
      @gh = Ghee.basic_auth(user, pass)

      #Test authentication, to_s required to have side-effects
      @gh.repos(user, repo).to_s
    end

    def create_pull_request(from:, to:, subject:, message:)
      @gh.repos(@user, @repo).pulls.create(:title => subject, :body => message, :base => to, :head => from)
    end
  end

  module TestHelpers 
    class Branch
      module Error
        class NoSuchRepository < StandardError; end
        class BadRepoSelector < StandardError; end
        class BadLogin < StandardError; end
        class NoSuchCloneURL< StandardError; end
      end

      #repo_selector is like 'my_user/repo'
      def initialize(user:, pass:, repo_selector:, clone_url:)
        @user = user
        @pass = pass
        @repo_selector = repo_selector
        @clone_url = clone_url


        #Setup the local git client
        ##############################################################
        Git.configure do |config|
          config.git_ssh = "./spec/assets/git_ssh"
        end
        ##############################################################

        clone_repo

        #Setup Octocat client
        ##############################################################
        @gh_client = Octokit::Client.new(:login => @user, :password => @pass)
        begin
          @gh_client.user #throw exception if auth is bad
        rescue Octokit::Unauthorized
          raise Error::BadLogin
        end

        begin
          @repo = @gh_client.repo(repo_selector)
        rescue ArgumentError
          raise Error::BadRepoSelector
        rescue Octokit::NotFound
          raise Error::NoSuchRepository
        end
        ##############################################################
      end

      #Will clone down repo and set @gh_client to the new repo
      def clone_repo
        #Create a temp path
        temp_file = Tempfile.new('pully')
        @path = temp_file.path
        temp_file.close
        temp_file.unlink

        #Clone repo
        begin
          @git_client = Git.clone(@clone_url, 'pully', :path => @path)
          raise "Git client is nil?" if @git_client.nil?
        rescue Git::GitExecuteError => e
          raise Error::NoSuchCloneURL if e.message =~ /fatal: repository.*does not exist/
        end
      end

      def create_branch(new_branch_name)
        #Checkout what ever real master is
        @git_client.branch(master_branch).checkout

        #Create a new branch
        @git_client.branch(new_branch_name)
        @git_client.branch(new_branch_name).checkout
      end

      def delete_branch(branch_name)
        @git_client.push("origin", ":#{branch_name}")
      end

      def list_branches
        #Re-pull repo from github
        clone_repo
        @git_client.branches.remote.map{|e| e.name}
      end

      def master_branch
        @repo.default_branch
      end

      #Create, commit, and push to github
      def commit_new_random_file(branch_name)
        #Create a new file
        Dir.chdir "#{@path}/pully" do
          File.write branch_name, branch_name
        end

        #Commit
        @git_client.add(:all => true)
        @git_client.commit_all("New branch from Pully Test Suite #{SecureRandom.hex}")
        @git_client.push("origin", branch_name)
      end
    end
  end

  def self.new(user:, pass:, repo:)
    Pully.new(user: user, pass: pass, repo: repo)
  end
end
