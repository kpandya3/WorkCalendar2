# WorkCalendar
A gem to do simple date calculations

## Installation
```console
git clone https://github.com/kpandya91/WorkCalendar.git 
cd WorkCalendar
gem build workcalendar.gemspec 
gem install workcalendar-0.1.0.gem 
```

## Configuration
```ruby
WorkCalendar.configure do |c|
  c.weekdays = %i[mon tue wed thu fri]
  c.holidays = [Date.new(2014, 12, 31), Date.new(2015, 1, 1), Date.new(2015, 7, 3), Date.new(2015, 12, 25), Date.new(2015, 4, 15), Date.new(2015, 9, 15), Date.new(2015, 11, 22)]
end
```

## Usage

Check if a date is active (is a weekday and not a holiday):
```ruby
# true if the given date is active, false otherwise
WorkCalendar.active?(Date.new(2015, 7, 3))
# => false

WorkCalendar.active?(Date.new(2015, 10, 14))
# => true
```

Get nth active date before the given date:
```ruby
WorkCalendar.days_before(7, Date.new(2015, 1, 8))
# => #<Date: 2014-12-26 ((2457018j,0s,0n),+0s,2299161j)>
```

Get nth active date after the given date:
```ruby
WorkCalendar.days_after(5, Date.new(2015, 4, 11))
# => #<Date: 2015-04-20 ((2457133j,0s,0n),+0s,2299161j)>
```

Get all active dates between the two given dates
```ruby
WorkCalendar.between(Date.new(2014, 12, 26), Date.new(2015, 1, 7))
#  => [
#     #<Date: 2014-12-26 ((2457018j,0s,0n),+0s,2299161j)>,
#     #<Date: 2014-12-29 ((2457021j,0s,0n),+0s,2299161j)>,
#     #<Date: 2014-12-30 ((2457022j,0s,0n),+0s,2299161j)>,
#     #<Date: 2015-01-02 ((2457025j,0s,0n),+0s,2299161j)>,
#     #<Date: 2015-01-05 ((2457028j,0s,0n),+0s,2299161j)>,
#     #<Date: 2015-01-06 ((2457029j,0s,0n),+0s,2299161j)>
#     ]
```
