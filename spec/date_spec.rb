require_relative './spec_helper'

describe Date do

	it 'should initialize with 3 params' do
		Date.new(2015,1,1)
	end

	context 'when WorkCalendar is not configured' do
		describe '#is_holiday?' do
			it 'should return nil' do
				expect(Date.new(2015,5,6).is_holiday?).to be_nil
			end
		end

		describe '#is_weekday?' do
			it 'should return nil' do
				expect(Date.new(2015,5,6).is_weekday?).to be_nil
			end
		end

		describe '#next_active_date' do
			it 'should return nil' do
				expect(Date.new(2014,12,19).next_active_date).to be_nil
			end
		end

		describe '#prev_active_date' do
			it 'should return nil' do
				expect(Date.new(2014,12,19).prev_active_date).to be_nil
			end
		end
	end

	context 'when WorkCalendar is configured' do
		before do
			WorkCalendar.configure do |c|
				c.weekdays = %i[mon tue wed fri]
				c.holidays = [Date.new(2014, 12, 31), Date.new(2015, 1, 1), Date.new(2015, 7, 3), Date.new(2015, 12, 25), Date.new(2015, 4, 15), Date.new(2015, 9, 15)]
			end
		end

		describe '#is_holiday?' do

			it 'should not return nil' do
				expect(Date.new(2014,5,7).is_holiday?).not_to be_nil
			end

			it 'should return true if holiday' do
				expect(Date.new(2015, 7, 3).is_holiday?).to be true
			end

			it 'should return false if not holiday' do
				expect(Date.new(2015, 10, 23).is_holiday?).to be false
			end
		end

		describe '#is_weekday?' do
			let(:weekday) { Date.new(2015, 7, 3) }
			let(:not_weekday) { Date.new(2015, 10, 18) }

			it 'should not return nil' do
				expect(Date.new(2014,5,7).is_weekday?).not_to be_nil
			end

			it 'should return true if weekday' do
				expect(weekday.is_weekday?).to be true
			end

			it 'should return false if not weekday' do
				expect(not_weekday.is_weekday?).to be false
			end
		end

		describe '#next_active_date' do
			it 'should get the next active day' do
				expect(Date.new(2015, 1, 11).next_active_date).to eq Date.new(2015, 1, 12)
			end

			it 'should skip over non-active days' do
				expect(Date.new(2015, 1, 7).next_active_date).to eq Date.new(2015, 1, 9)
			end

			it 'should skip over holidays' do
				expect(Date.new(2014, 12, 30).next_active_date).to eq Date.new(2015, 1, 2)
			end

			it 'should skip over holidays and non-active days in a row' do
				expect(Date.new(2015, 7, 1).next_active_date).to eq Date.new(2015, 7, 6)
			end
		end

		describe '#prev_active_date' do
			it 'should get the previous active day' do
				expect(Date.new(2015, 1, 13).prev_active_date).to eq Date.new(2015, 1, 12)
			end

			it 'should skip over non-active days' do
				expect(Date.new(2015, 3, 27).prev_active_date).to eq Date.new(2015, 3, 25)
			end

			it 'should skip over holidays' do
				expect(Date.new(2015, 9, 16).prev_active_date).to eq Date.new(2015, 9, 14)
			end

			it 'should skip over holidays and non-active days in a row' do
				expect(Date.new(2015, 4, 17).prev_active_date).to eq Date.new(2015, 4, 14)
			end
		end
	end
end
