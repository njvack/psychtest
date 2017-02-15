# An Assessment is one person completing one task one time. Basically,
# one instance of us "assessing" their performance.
class Assessment < ApplicationRecord
  has_many :events
  has_many :measurements

  def add_events(event_list)
    event_list.map { |event|
      event['uniqie_id'] if events.create(
        :relative_timestamp => event['timestamp'],
        :unique_id => event['unique_id'],
        :event_json => event['event']
      )
    }.reject(&:nil?)
  end

  def add_measurements(measurement_list)
    measurement_list.map { |measurement|
      measurement['uniqie_id'] if measurements.create(
        :unique_id => measurement['unique_id'],
        :category => measurement['type'],
        :value => measurement['value']
      )
    }.reject(&:nil?)
  end
end
