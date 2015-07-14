require 'date'
require_relative "workcalendar/configuration"

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
			is_weekday?(date) && !is_holiday?(date)
		end

		# Returns nth active date before the current date
		# 
		# +n+ - number of dates to go back till
		# +date+ - Date to go back on
		# 
		def days_before(n, date)
			return nil if !configuration
			n.times { date = prev_active_date(date) }
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
			n.times { date = next_active_date(date) }
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
			res << date1 if !is_holiday?(date1)
			cur_date = next_active_date(date1)
			while cur_date < date2
				res << cur_date
				# We can also use *days_after(1, cur_date)* to get next date
				cur_date = next_active_date(cur_date)
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

	private

		# Returns true if date is in the set of holidays
		def is_holiday?(date)
			configuration ? configuration.holidays.include?(date) : nil
		end

		# Returns true if date is a weekday
		def is_weekday?(date)
			# True if the previous day takes one day to get to next active day/current day
			configuration ? configuration.weekdays[(date.wday - 1)%7][:+] == 1 : nil
		end

		# Returns next active date
		def next_active_date(date)
			get_active_date(date)
		end

		# Returns previous active date
		def prev_active_date(date)
			get_active_date(date, :-)
		end

		# Returns next active date (next date that is a weekday and not a holiday)
		def get_active_date(date, operator=:+)
			return nil if !configuration
			# Set cur_date to next (or previous) weekday
			# Note: Because of the WorkCalendar.configuration.weekdays data structure, we make sure that we only iterate over weekdays
			cur_date = date.send(operator, configuration.weekdays[date.wday][operator])
			loop do
				# If cur_date isn't holiday, we found the next active date
				break if !is_holiday?(cur_date)
				# Else we keep iterating
				cur_date = cur_date.send(operator, configuration.weekdays[cur_date.wday][operator])
			end
			cur_date
		end
	end
end # WorkCalendar
