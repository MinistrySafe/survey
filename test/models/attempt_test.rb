require 'test_helper'

class AttemptTest < ActiveSupport::TestCase
  NUMBER_OF_ATTEMPTS = 5

  test "should pass if the user has #{NUMBER_OF_ATTEMPTS} attempts completed" do
    user = create_user
    survey = create_survey(attempts_number: NUMBER_OF_ATTEMPTS)
    NUMBER_OF_ATTEMPTS.times { create_attempt_for(user, survey) }
    assert_equal NUMBER_OF_ATTEMPTS, number_of_current_attempts(user, survey)
  end

  test 'should raise error when the User tries to respond more times than acceptable' do
    user = create_user
    survey = create_survey(attempts_number: NUMBER_OF_ATTEMPTS)
    (NUMBER_OF_ATTEMPTS + 1).times { create_attempt_for(user, survey) }
    assert_not_equal (NUMBER_OF_ATTEMPTS + 1), number_of_current_attempts(user, survey)
    assert_equal NUMBER_OF_ATTEMPTS, number_of_current_attempts(user, survey)
  end

  test 'exclude_survey returns only attempts for other surveys' do
    user = create_user
    survey_a = create_survey
    survey_b = create_survey
    attempt_a = create_attempt_for(user, survey_a)
    attempt_b = create_attempt_for(user, survey_b)

    # Scope to this user: the in-memory DB is shared across tests.
    users_attempts = Survey::Attempt.for_participant(user)
    assert_equal [attempt_b.id], users_attempts.exclude_survey(survey_a).pluck(:id)
    assert_equal [attempt_a.id], users_attempts.exclude_survey(survey_b).pluck(:id)
  end

  test 'should not create an attempt without a survey or participant' do
    should_not_be_persisted create_attempt(user: create_user)
    should_not_be_persisted create_attempt(survey: create_survey)
  end
end
