require_relative "./spec_helper"

describe WorkCalendar do
	context 'when WorkCalendar is not configured' do
		describe '.configuration' do
			it 'should be nil' do
				expect(WorkCalendar.configuration).to eq nil
			end
		end

		describe '.active?' do
			it 'should return nil' do
				expect(WorkCalendar.active?(Date.new(2015,4,20))).to eq nil
			end
		end
	end

	context 'when WorkCalendar is configured' do
	end
end
