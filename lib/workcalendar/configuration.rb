module WorkCalendar
	class Configuration
		attr_accessor :weekdays, :holidays

		def initialize
			@weekdays = %i[mon tue wed thu fri]
			@holidays = []
		end
	end
end
