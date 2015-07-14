require_relative "./spec_helper"

describe WorkCalendar do

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

	describe '.configure' do
		let(:holidays) { [Date.new(2014, 12, 31), Date.new(2015, 1, 1), Date.new(2015, 7, 3), Date.new(2015, 12, 25), Date.new(2015, 4, 15), Date.new(2015, 9, 15)] }
		let(:weekdays_hash) { {0=>{:+=>2, :-=>2}, 1=>{:+=>1, :-=>3}, 2=>{:+=>1, :-=>4}, 3=>{:+=>1, :-=>1}, 4=>{:+=>1, :-=>1}, 5=>{:+=>4, :-=>1}, 6=>{:+=>3, :-=>1}} }

		before(:context) do
			WorkCalendar.configure do |c|
				c.holidays = [Date.new(2014, 12, 31), Date.new(2015, 1, 1), Date.new(2015, 7, 3), Date.new(2015, 12, 25), Date.new(2015, 4, 15), Date.new(2015, 9, 15)]
				c.weekdays = %i[tue wed thu fri]
			end
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

			it 'should return previous date' do
				expect(WorkCalendar.days_before(1, Date.new(2015, 5, 26))).to eq Date.new(2015, 5, 25)
			end

			it 'should skip over non-active days' do
				expect(WorkCalendar.days_before(7, Date.new(2015, 10, 18))).to eq Date.new(2015, 10, 6)
			end

			it 'should skip over holidays' do
				expect(WorkCalendar.days_before(3, Date.new(2015, 9, 17))).to eq Date.new(2015, 9, 11)
			end

			it 'should skip over both non-active days and holidays' do
				expect(WorkCalendar.days_before(3, Date.new(2015, 1, 2))).to eq Date.new(2014, 12, 26)
			end
		end

		describe '.days_after' do

			it 'should return previous date' do
				expect(WorkCalendar.days_after(1, Date.new(2015, 5, 25))).to eq Date.new(2015, 5, 26)
			end

			it 'should skip over non-active days' do
				expect(WorkCalendar.days_after(7, Date.new(2015, 10, 6))).to eq Date.new(2015, 10, 19)
			end

			it 'should skip over holidays' do
				expect(WorkCalendar.days_after(3, Date.new(2015, 9, 11))).to eq Date.new(2015, 9, 18)
			end

			it 'should skip over both non-active days and holidays' do
				expect(WorkCalendar.days_after(3, Date.new(2014, 12, 26))).to eq Date.new(2015, 1, 2)
			end
		end

		describe '.between' do

			it 'should raise if start date is not smaller than end date' do
				expect { WorkCalendar.between(Date.new(2015, 2, 17), Date.new(2014, 12, 26)) }.to raise_error(RuntimeError, "Ending date is not bigger than starting date")
			end

			it 'should return empty array when start and end dates are same' do
				expect(WorkCalendar.between(Date.new(2014, 12, 26), Date.new(2014, 12, 26))).to eq Array.new
			end

			it 'should return array with only date1 when range is 1' do
				expect(WorkCalendar.between(Date.new(2014, 12, 26), Date.new(2014, 12, 27))).to eq [Date.new(2014, 12, 26)]
			end

			it 'should return array of active days only' do
				expect(WorkCalendar.between(Date.new(2014, 12, 26), Date.new(2015, 1, 6))).to eq 	[
																										Date.new(2014, 12, 26),
																										Date.new(2014, 12, 29),
																										Date.new(2014, 12, 30),
																										Date.new(2015, 1, 2),
																										Date.new(2015, 1, 5)
																									]
			end

			it 'should not include holidays' do
				expect(WorkCalendar.between(Date.new(2014, 12, 26), Date.new(2015, 1, 3))).not_to include(Date.new(2015,1,1))
				expect(WorkCalendar.between(Date.new(2014, 12, 26), Date.new(2015, 1, 3))).not_to include(Date.new(2014,12,31))
			end

			it 'should not include non-active days' do
				expect(WorkCalendar.between(Date.new(2014, 12, 26), Date.new(2015, 1, 3))).not_to include(Date.new(2014,12,27))
				expect(WorkCalendar.between(Date.new(2014, 12, 26), Date.new(2015, 1, 3))).not_to include(Date.new(2014,1,3))
			end

			it 'should not include ending date' do
				expect(WorkCalendar.between(Date.new(2014, 12, 26), Date.new(2015, 1, 5))).not_to include(Date.new(2014,1,5))
			end
		end

	end
end
