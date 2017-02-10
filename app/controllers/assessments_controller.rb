# Our only controller for now! Handle creating assessments and saving
# responses in them.
class AssessmentsController < ApplicationController
  def index; end

  protected

  def current_assessment
    @current_assessment ||= find_or_create_current_assessment
  end
  helper_method :current_assessment

  def find_or_create_current_assessment
    assessment = Assessment.where(:id => session[:assessment_id]).first
    return assessment if assessment

    # If we're here, we need to create one.
    assessment = Assessment.create!
    session[:assessment_id] = assessment.id
    assessment
  end
end
