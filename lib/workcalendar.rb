require "workcalendar/date"
require "workcalendar/configuration"

# Main module for workcalendar gem
module WorkCalendar

	class << self
		# Gets and sets the configuration for WorkCalendar module
		attr_accessor :configuration

		# Return true if date is active, false otherwise
		# 
		# +date+ - Date to check for
		# 
		def active?(date)
			# Date is active if it's a weekday and it's not a holiday
			date.is_weekday? && !date.is_holiday?
		end

		# Returns nth active date before the current date
		# 
		# +n+ - number of dates to go back till
		# +date+ - Date to go back on
		# 
		def days_before(n, date)
			loop do
				# Set date to previous active date
				date = date.get_active_date(:-)
				n -= 1
				# Found the date when end of counter
				break if n == 0
			end
			date
		end

		# Returns nth active date after the current date
		# 
		# +n+ - Number of dates to go forward till
		# +date+ - Date to go forward on
		# 
		def days_after(n, date)
			loop do
				# Set date to next active date
				date = date.get_active_date
				n -= 1
				# Found the date when end of counter
				break if n == 0
			end
			date
		end

		# Returns an array of all active dates beween two given dates
		# 
		# +date1+ - Starting date range
		# +date2+ - Ending date range
		# 
		def between(date1, date2)
			# If 
			raise "Starting date ends before ending date" if date1 > date2
			cur_date = date1
			res = Array.new
			while cur_date < date2
				res << cur_date
				# We can also use *days_after(1, cur_date)* to get next date
				cur_date = cur_date.get_active_date
			end
			res
		end

		# 
		def configure
			self.configuration ||= Configuration.new
			yield(configuration)
		end

	end
end # WorkCalendar
