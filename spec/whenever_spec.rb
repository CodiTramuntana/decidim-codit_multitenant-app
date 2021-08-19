# frozen_string_literal: true

require "spec_helper"

# rubocop: disable RSpec/DescribeClass
describe "Whenever Schedule" do
  before do
    load "Rakefile"
  end

  let(:schedule) { Whenever::Test::Schedule.new(file: "config/schedule.rb") }
  let(:rake) { schedule.jobs[:rake] }
  let(:task) { rake.first[:task] }
  let(:every) { rake.first[:every] }
  let(:command) { rake.first[:command] }

  it "makes sure `rake` statements exist" do
    expect(rake.count).to eq(1)
  end

  it "makes sure the rake task raises no exception" do
    expect { Rake::Task[task].invoke }.not_to raise_error
  end

  it "makes sure the schedule is correct" do
    expect(every[0]).to eq(1.day)
    expect(every[1][:at]).to eq("2:00 am")
  end

  it "makes sure a command is generated" do
    expect(command).to be_truthy
  end
end
# rubocop: enable RSpec/DescribeClass
