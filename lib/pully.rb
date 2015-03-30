require "pully/version"
require 'ghee'
require 'octokit'

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
      end

      #repo_selector is like 'my_user/repo'
      def initialize(user:, pass:, repo_selector:)
        @user = user
        @pass = pass
        @repo_selector = repo_selector

        @client = Octokit::Client.new(:login => @user, :password => @pass)
        @client.user #throw exception if auth is bad

        begin
          @client.repo(repo_selector).inspect
        rescue ArgumentError => e
          raise Error::BadRepoSelector
        rescue Octokit::NotFound
          raise Error::NoSuchRepository
        end
      end

      def create_branch_off_master(name)
      end

      def commit_new_random_file(branch_name)
      end
    end
  end

  def self.new(user:, pass:, repo:)
    Pully.new(user: user, pass: pass, repo: repo)
  end
end
