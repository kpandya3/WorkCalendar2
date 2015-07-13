require "date"
require "../lib/workcalendar/configuration.rb"

describe WorkCalendar::Configuration do

	let(:holidays) { [Date.new(2015, 1, 1), Date.new(2015, 7, 3), Date.new(2015, 12, 25)] }
	let(:weekdays) { %i[fri tue wed mon] }

	subject(:config) {
		described_class.new do |c|
			c.weekdays = weekdays
			c.holidays = holidays
		end
	}

	context 'when initialized without block' do
		it 'does not raise' do
			expect { described_class.new }.not_to raise_error
		end
	end

	describe '.get_norp_wday' do

		let(:active_days) { Set.new %i[fri tue wed mon] }

		it 'should detect default operator to be :+' do
			expect(WorkCalendar::Configuration.get_norp_wday(1, active_days)).to eq 1
		end

		it 'should skip over non-active days' do
			expect(WorkCalendar::Configuration.get_norp_wday(5, active_days)).to eq 3
		end

		it 'should gets active day right before the current day' do
			expect(WorkCalendar::Configuration.get_norp_wday(2, active_days, :-)).to eq 1
		end

		it 'should get previous active day' do
			expect(WorkCalendar::Configuration.get_norp_wday(5, active_days, :-)).to eq 2
		end
	end

	describe '.get_weekday_delta' do
		context 'when empty array passed in' do
			let(:weekdays) { %i[] }

			it 'should raise' do
				expect { WorkCalendar::Configuration.get_weekday_delta(weekdays) }.to raise_error(RuntimeError)
			end
		end

		context 'when invalid array passed in' do
			let(:weekdays) { %i[Friday Tue wednesday MON] }

			it 'should raise' do
				expect { WorkCalendar::Configuration.get_weekday_delta(weekdays) }.to raise_error(RuntimeError)
			end
		end

		context 'when duplicate values are provided' do
			let(:weekdays) { %i[fri tue wed tue mon] }
			let(:res_set) {  {0=>{:+=>1, :-=>2}, 1=>{:+=>1, :-=>3}, 2=>{:+=>1, :-=>1}, 3=>{:+=>2, :-=>1}, 4=>{:+=>1, :-=>1}, 5=>{:+=>3, :-=>2}, 6=>{:+=>2, :-=>1}} }

			it 'should not raise' do
				expect { WorkCalendar::Configuration.get_weekday_delta(weekdays) }.not_to raise_error
			end

			it 'should return expected' do
				expect(WorkCalendar::Configuration.get_weekday_delta(weekdays)).to eq res_set
			end
		end
	end

	describe '#holidays' do
		let(:holidays) { [Date.new(2015, 1, 1), Date.new(2015, 7, 3), Date.new(2015, 12, 25)] }

		it 'returns set of holidays' do
			expect(config.holidays).to eq Set.new(holidays)
		end

		context 'when duplicate values provided' do
			it 'does not raise' do
				expect {  }
			end
		end
	end

	# before(:each) do
	# 	@config = WorkCalendar::Configuration.new
	# end

	# it "" do

	# end
end
