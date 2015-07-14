require_relative "workcalendar/date"
require_relative "workcalendar/configuration"

# Main module for workcalendar gem
module WorkCalendar

	module ClassMethods
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
			return nil if !configuration
			n.times { date = date.prev_active_date }
			date
		end

		# Returns nth active date after the current date
		# 
		# +n+ - Number of dates to go forward till
		# +date+ - Date to go forward on
		# +operator+ - Operator to get date after given date or date before given date
		# 
		def days_after(n, date)
			return nil if !configuration
			n.times { date = date.next_active_date }
			date
		end

		# Returns an array of all active dates beween two given dates
		# 
		# +date1+ - Starting date range
		# +date2+ - Ending date range
		# 
		def between(date1, date2)
			# Make sure WorkCalendar is configured
			return nil if !configuration

			# Returns empty array if start and end dates are same
			return [] if date1 == date2

			# If date1 isn't smaller than date2, we throw error
			raise "Ending date is not bigger than starting date" if date1 > date2

			# Create result set and add date1 if its not holiday
			res = Array.new

			# If date1 isn't holiday, add date1 to result set
			res << date1 if !date1.is_holiday?
			cur_date = date1.next_active_date
			while cur_date < date2
				res << cur_date
				# We can also use *days_after(1, cur_date)* to get next date
				cur_date = cur_date.next_active_date
			end
			res
		end

		# Yields WorkCalendar configuration
		def configure(&block)
			# Create new configuration if it doesn't already exists
			self.configuration ||= Configuration.new

			# Yield for block if block given
			yield(configuration) if block
		end
	end

	extend ClassMethods

end # WorkCalendar
