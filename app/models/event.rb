# An Event is anything potentially interesting that happens during an assessment.
# Examples include displaying a stimulus, getting a keypress response, the start
# of a task or trial.
# Events have a timestamp (milliseconds, relative to the start of the assessment)
# and an event_json field that contains most of the data. Stored, unsurprisingly,
# as json.
# In addition, Events contain a numeric unique_id field that must be unique in a
# given Assessment. This should be provided by the client, and is to guard against
# network problems causing events to be stored more than once.
class Event < ApplicationRecord
  belongs_to :assessment
end
