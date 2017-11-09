Feature: Keep the depth of detail low

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(AvoidSentencesStartingWith)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Sentences starting with "I click on...", "I see...", "I should see...", "I go to..."
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given I click on button 1
          And I see button 2
          When I should be redirected to page 3
          Then I go to the redirected page 4
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      AvoidSentencesStartingWith (Warning) - avoid steps starting with "I click...", "I see...", "I should...", "I go to..."
        lint.feature (3): Test.A step: I click on button 1
      AvoidSentencesStartingWith (Warning) - avoid steps starting with "I click...", "I see...", "I should...", "I go to..."
        lint.feature (4): Test.A step: I see button 2
      AvoidSentencesStartingWith (Warning) - avoid steps starting with "I click...", "I see...", "I should...", "I go to..."
        lint.feature (4): Test.A step: I should be redirected to page 3
      AvoidSentencesStartingWith (Warning) - avoid steps starting with "I click...", "I see...", "I should...", "I go to..."
        lint.feature (4): Test.A step: I go to the redirected page 4

      """

  Scenario: Valid example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given I choose option 1
          And button 2 is visible
          When I am redirected to page 3
          Then I navigate to the redirected page 4
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
