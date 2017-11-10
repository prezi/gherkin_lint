Feature: Prezi avoid sentences starting with

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(AvoidSentencesContaining)
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
      AvoidSentencesContaining - Avoid steps containing with "I click...", "I see...", "I should...", "I go to...", "I fill"
        lint.feature (3): Test.A step: I click on button 1
      AvoidSentencesContaining - Avoid steps containing with "I click...", "I see...", "I should...", "I go to...", "I fill"
        lint.feature (4): Test.A step: I see button 2
      AvoidSentencesContaining - Avoid steps containing with "I click...", "I see...", "I should...", "I go to...", "I fill"
        lint.feature (5): Test.A step: I should be redirected to page 3
      AvoidSentencesContaining - Avoid steps containing with "I click...", "I see...", "I should...", "I go to...", "I fill"
        lint.feature (6): Test.A step: I go to the redirected page 4

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
