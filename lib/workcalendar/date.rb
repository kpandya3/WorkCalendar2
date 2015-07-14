require "date"

# == Date class
# 
# Adds extra functionality to existing date library
# 
class Date

	# Returns true if self is in the set of holidays
	def is_holiday?
		WorkCalendar.configuration ? WorkCalendar.configuration.holidays.include?(self) : nil
	end

	# Returns true if self is a weekday
	def is_weekday?
		# True if the previous day takes one day to get to next active day/current day
		WorkCalendar.configuration ? WorkCalendar.configuration.weekdays[(self.wday - 1)%7][:+] == 1 : nil
	end

	# Returns next active date
	def next_active_date
		get_active_date
	end

	# Returns previous active date
	def prev_active_date
		get_active_date(:-)
	end

private

	# Returns next active date (next date that is a weekday and not a holiday)
	def get_active_date(operator=:+)
		return nil if !WorkCalendar.configuration
		# Set cur_date to next (or previous) weekday
		# Note: Because of the WorkCalendar.configuration.weekdays data structure, we make sure that we only iterate over weekdays
		cur_date = self.send(operator, WorkCalendar.configuration.weekdays[self.wday][operator])
		loop do
			# If cur_date isn't holiday, we found the next active date
			break if !cur_date.is_holiday?
			# Else we keep iterating
			cur_date = cur_date.send(operator, WorkCalendar.configuration.weekdays[cur_date.wday][operator])
		end
		cur_date
	end

end # Date
