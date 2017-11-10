Feature: Prezi avoid sentences starting with

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(AvoidQuotes)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Avoid using quotes in steps
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given I click on "button 1"
          And I click on 'button 2'
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      AvoidQuotes - Avoid using quotes in steps
        lint.feature (3): Test.A step: I click on button 1
      AvoidQuotes - Avoid using quotes in steps
        lint.feature (4): Test.A step: I see button 2

      """

  Scenario: Valid example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given I click on button 1
          And I click on button 2
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
