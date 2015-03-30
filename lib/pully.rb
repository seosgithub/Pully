require "pully/version"
require 'ghee'

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
      def initialize(user:, pass:)
        @user = user
        @pass = pass
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
