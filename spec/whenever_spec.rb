require 'spec_helper'

describe 'Whenever Schedule' do
  before do
    load 'Rakefile' # Makes sure rake tasks are loaded so you can assert in rake jobs
  end

  let(:schedule) { Whenever::Test::Schedule.new(file: 'config/schedule.rb') }
  let(:rake) { schedule.jobs[:rake] }
  let(:task) { rake.first[:task] }
  let(:every) { rake.first[:every] }
  let(:command) { rake.first[:command] }

  it 'makes sure `rake` statements exist' do
    expect(schedule.jobs[:rake].count).to eq(1)
  end

  it 'makes sure `rake` task doesnt crash' do
    expect(Rake::Task[task].invoke).to be_truthy
  end

  it "makes sure the schedule is correct" do
    expect(every[0]).to eq(1.day)
    expect(every[1][:at]).to eq("2:00 am")
  end

  it 'makes sure `command` statements exist' do
    expect(command).to be_truthy
  end
end
