# Our only controller for now! Handle creating assessments and saving
# responses in them.
class AssessmentsController < ApplicationController
  def index; end

  def update
    event_ids = current_assessment.add_events(params[:events])
    meas_ids = current_assessment.add_measurements(params[:measurements])
    logger.debug { "Added events #{event_ids.inspect}" }
    logger.debug { "Added measurements #{meas_ids.inspect}" }
    current_assessment.update_attribute(:completed, params[:completed])
    logger.debug params[:events].inspect
    logger.debug params[:measurements].to_json
    session.destroy if params[:completed]
  end

  protected

  def current_assessment
    @current_assessment ||= find_or_create_current_assessment
  end
  helper_method :current_assessment

  def find_or_create_current_assessment
    assessment = Assessment.where(:id => session[:assessment_id]).first
    return assessment if assessment

    # If we're here, we need to create one.
    assessment = Assessment.create! :user_agent => request.headers['User-Agent']
    session[:assessment_id] = assessment.id
    assessment
  end
end
