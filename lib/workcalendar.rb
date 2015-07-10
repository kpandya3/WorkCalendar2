require "date"
require "workcalendar/configuration"

module WorkCalendar
	class << self
		attr_accessor :configuration
	end

	def self.configure
		self.configuration ||= Configuration.new
		yield(configuration)
	end
end
