Feature: Avoid sentences containing bad words

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(PreziAvoidStepsContaining)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Steps containing bad words
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When I see the button
          Then verify
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      PreziAvoidStepsContaining (Warning) - Avoid steps containing with "I click", "I see", "I should", "I go to", "I fill"
        lint.feature (4): Test.A step: I see the button
        https://prezidoc.atlassian.net/wiki/spaces/WEB/pages/270632203/Gherkin+Linter#GherkinLinter-PreziAvoidStepsContaining

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When test
          Then verification
          When test
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
