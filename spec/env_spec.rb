require 'yaml'
require 'ghee'
require './lib/pully.rb'
require 'securerandom'

RSpec.describe "Test Environment" do
  it "Can write to a tempfile" do
    #Create a temp path
    temp_file = Tempfile.new('pully')
    @path = temp_file.path
    temp_file.close
    temp_file.unlink

    File.write temp_file, "test"
    str = File.read temp_file
    expect(str).to eq("test")
  end
end
