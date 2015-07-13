require "workcalendar/date"
require "workcalendar/configuration"

# Main module for workcalendar gem
module WorkCalendar

	class << self
		# Gets and sets the configuration for WorkCalendar module
		attr_accessor :configuration

		# Initially set the configuration to new configuration so user can use the gem right away
		configuration = Configuration.new

		# Return true if date is active, false otherwise
		# 
		# +date+ - Date to check for
		# 
		def active?(date)
			# Date is active if it's a weekday and it's not a holiday
			date.is_weekday? && !date.is_holiday?
		end

		# 
		def configure
			self.configuration ||= Configuration.new
			yield(configuration)
		end

	end
end # WorkCalendar
