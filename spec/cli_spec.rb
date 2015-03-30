require './lib/pully.rb'
require 'tempfile'
require 'securerandom'

def ensure_tmp
  tmp_spec_path = './spec/tmp'
  Dir.mkdir(tmp_spec_path) unless File.exists?(tmp_spec_path)
end

RSpec.describe "CLI" do
  it "Runs" do
    a = `ruby -Ilib ./bin/pully test`
    expect(a).to eq("ok\n")
  end
end
