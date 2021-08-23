# frozen_string_literal: true

require "spec_helper"

# rubocop: disable RSpec/DescribeClass
describe "Whenever Schedule" do
  before do
    load "Rakefile"
  end

  let(:schedule) { Whenever::Test::Schedule.new(file: "config/schedule.rb") }
  let(:rake_jobs) { schedule.jobs[:rake] }

  it "makes sure `rake` statements exist" do
    expect(rake_jobs.count).to eq(3)
  end

  context "when metrics_all scheduled" do
    let(:rake_job) { rake_jobs.first }

    it "makes sure the metrics_all rake task raises no exception" do
      task = rake_job[:task]
      expect { Rake::Task[task].invoke }.not_to raise_error
    end

    it "makes sure metrics_all schedule is correct" do
      every = rake_job[:every]
      expect(every[0]).to eq(1.day)
      expect(every[1][:at]).to eq("5:00 am")
    end

    it "makes sure metrics_all command is generated" do
      expect(rake_job[:command]).to be_truthy
    end
  end

  context "when open data exports are scheduled" do
    let(:rake_job) { rake_jobs.second }

    it "makes sure the open data exports rake task raises no exception" do
      task = rake_job[:task]
      expect { Rake::Task[task].invoke }.not_to raise_error
    end

    it "makes sure open data exports schedule is correct" do
      every = rake_job[:every]
      expect(every[0]).to eq(1.day)
      expect(every[1][:at]).to eq("6:00 am")
    end

    it "makes sure open data exports command is generated" do
      expect(rake_job[:command]).to be_truthy
    end
  end

  context "when delete_data_portability_files are scheduled" do
    let(:rake_job) { rake_jobs.third }

    it "makes sure the delete_data_portability_files rake task raises no exception" do
      task = rake_job[:task]
      expect { Rake::Task[task].invoke }.not_to raise_error
    end

    it "makes sure delete_data_portability_files schedule is correct" do
      every = rake_job[:every]
      expect(every[0]).to eq(:sunday)
      expect(every[1][:at]).to eq("4:00 am")
    end

    it "makes sure delete_data_portability_files command is generated" do
      expect(rake_job[:command]).to be_truthy
    end
  end
end
# rubocop: enable RSpec/DescribeClass
