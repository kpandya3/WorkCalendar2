require_relative "./spec_helper"

describe WorkCalendar do

	describe '.configure' do
		let(:holidays) { [Date.new(2014, 12, 31), Date.new(2015, 1, 1), Date.new(2015, 7, 3), Date.new(2015, 12, 25), Date.new(2015, 4, 15), Date.new(2015, 9, 15)] }
		let(:weekdays_hash) { {0=>{:+=>2, :-=>2}, 1=>{:+=>1, :-=>3}, 2=>{:+=>1, :-=>4}, 3=>{:+=>1, :-=>1}, 4=>{:+=>1, :-=>1}, 5=>{:+=>4, :-=>1}, 6=>{:+=>3, :-=>1}} }

		before(:context) do
			WorkCalendar.configure do |c|
				c.holidays = [Date.new(2014, 12, 31), Date.new(2015, 1, 1), Date.new(2015, 7, 3), Date.new(2015, 12, 25), Date.new(2015, 4, 15), Date.new(2015, 9, 15)]
				c.weekdays = %i[tue wed thu fri]
			end
		end

		after(:context) do
			WorkCalendar.configuration = nil
		end

		it 'configures if no block given' do
			expect { WorkCalendar.configure }.not_to raise_error
		end

		it 'sets WorkCalendar.configuration with given block' do
			expect(WorkCalendar.configuration).not_to be_nil
		end

		it 'sets the holidays to Set of given days' do
			expect(WorkCalendar.configuration.holidays).to eq Set.new holidays
		end

		it 'sets weekdays to Hash of days-delta pair' do
			expect(WorkCalendar.configuration.weekdays).to eq weekdays_hash
		end
	end

	context 'when WorkCalendar is not configured' do
		describe '.configuration' do
			it 'should be nil' do
				expect(WorkCalendar.configuration).to be_nil
			end
		end

		describe '.active?' do
			it 'should return nil' do
				expect(WorkCalendar.active?(Date.new(2015,4,20))).to be_nil
			end
		end

		describe '.days_before' do
			it 'should return nil' do
				expect(WorkCalendar.days_before(7, Date.new(2015, 10, 18))).to be_nil
			end
		end

		describe '.days_after' do
			it 'should return nil' do
				expect(WorkCalendar.days_after(3, Date.new(2015, 6, 7))).to be_nil
			end
		end

		describe '.between' do
			it 'should return nil' do
				expect(WorkCalendar.between(Date.new(2015,4,20), Date.new(2015,4,25))).to be_nil
			end
		end
	end

	context 'when WorkCalendar is configured' do
		before(:context) do
			WorkCalendar.configure do |c|
				c.weekdays = %i[mon tue wed fri]
				c.holidays = [Date.new(2014, 12, 31), Date.new(2015, 1, 1), Date.new(2015, 7, 3), Date.new(2015, 12, 25), Date.new(2015, 4, 15), Date.new(2015, 9, 15), Date.new(2015, 11, 22)]
			end
		end

		describe '.configuration' do
			it 'should not be nil' do
				expect(WorkCalendar.configuration).not_to be_nil
			end
		end

		describe '.active?' do
			it 'should not return nil' do
				expect(WorkCalendar.active?(Date.new(2015, 4, 20))).not_to be_nil
			end

			it 'should return true when date is weekday and not a holiday' do
				expect(WorkCalendar.active?(Date.new(2015, 4, 20))).to be true
			end

			it 'should return false if weekday and holiday' do
				expect(WorkCalendar.active?(Date.new(2014, 12, 31))).to be false
			end

			it 'should return false if not a weekday' do
				expect(WorkCalendar.active?(Date.new(2015, 6, 21))).to be false
			end

			it 'should return false if holiday and not a weekday' do
				expect(WorkCalendar.active?(Date.new(2015, 11, 22))).to be false
			end
		end

		describe '.days_before' do
			it 'should not return nil' do
				expect(WorkCalendar.days_before(7, Date.new(2015, 10, 18))).not_to be_nil
			end
		end

		describe '.days_after' do
			it 'should not return nil' do
				expect(WorkCalendar.days_after(3, Date.new(2015, 6, 7))).not_to be_nil
			end
		end

		describe '.between' do
			it 'should not return nil' do
				expect(WorkCalendar.between(Date.new(2015,4,20), Date.new(2015,4,25))).not_to be_nil
			end
		end

	end
end
