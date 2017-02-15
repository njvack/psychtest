# A Measurement is a numerical thing that happens during an assessment. Examples
# would include things like reaction times, correct/incorrect responses, and the
# derived computations thereof, such as means and standard deviations.
# Basically, these exist so researchers can get a quick look at the stuff that
# happened during an assessment, and so the app can do things like QA checks
# and histograms.
# This contains:
# `type` -- a string that has meaning to researchers
# `value` -- a floating point number
# `unique_id` -- an integer that must be unique for this assessment.
class Measurement < ApplicationRecord
  belongs_to :assessment
  validates :category, :presence => true
  validates :value, :presence => true, :numericality => true
  validates :unique_id, :presence => true, :uniqueness => { :scope => :assessment_id }
end
