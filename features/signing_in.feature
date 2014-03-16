Feature: Signing in

  Scenario: Unsuccessful signin
    Given a user visits the signin page
    When he submits invalid signin information
    Then he should see an error message

  Scenario: Successful signin
    Given a user visits the signin page
      And he has an account
    When he submits valid signin information
    Then he should see his profile page
      And he should see a signout link