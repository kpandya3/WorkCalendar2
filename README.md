# WorkCalendar
A simple gem to do simple date calculations

## Installation
```
git clone https://github.com/kpandya91/WorkCalendar.git 
cd WorkCalendar
gem build workcalendar.gemspec 
gem install workcalendar-0.1.0.gem 
```

## Configuration
```ruby
WorkCalendar.configure do |c|
  c.weekdays = %i[mon tue wed thu fri]
  c.holidays = [Date.new(2015, 1, 1), Date.new(2015, 7, 3), Date.new(2015, 12, 25)]
end
```

## Usage
```ruby
WorkCalendar.active?(Date.new(2015, 1, 1))
# => false

WorkCalendar.active?(Date.new(2015, 1, 2))
# => true

WorkCalendar.active?(Date.new(2015, 1, 3))
# => false

WorkCalendar.days_before(5, Date.new(2015, 1, 8))
# => #<Date: 2014-12-31 ((2457023j,0s,0n),+0s,2299161j)>

WorkCalendar.days_after(5, Date.new(2015, 1, 1))
# => #<Date: 2015-01-08 ((2457031j,0s,0n),+0s,2299161j)>

WorkCalendar.between(Date.new(2014, 12, 30), Date.new(2015, 1, 15))
#  => [
#   #<Date: 2014-12-30 ((2457023j,0s,0n),+0s,2299161j)>,
#   #<Date: 2014-12-31 ((2457023j,0s,0n),+0s,2299161j)>,
#   #<Date: 2015-01-02 ((2457025j,0s,0n),+0s,2299161j)>,
#   #<Date: 2015-01-05 ((2457028j,0s,0n),+0s,2299161j)>,
#   #<Date: 2015-01-06 ((2457029j,0s,0n),+0s,2299161j)>,
#   #<Date: 2015-01-07 ((2457030j,0s,0n),+0s,2299161j)>,
#   #<Date: 2015-01-08 ((2457031j,0s,0n),+0s,2299161j)>,
#   #<Date: 2015-01-09 ((2457032j,0s,0n),+0s,2299161j)>,
#   #<Date: 2015-01-12 ((2457035j,0s,0n),+0s,2299161j)>,
#   #<Date: 2015-01-13 ((2457036j,0s,0n),+0s,2299161j)>,
#   #<Date: 2015-01-14 ((2457037j,0s,0n),+0s,2299161j)>
# ]
```
