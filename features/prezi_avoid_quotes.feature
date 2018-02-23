Feature: Avoid quotes

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(PreziAvoidQuotes)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Step containing quotes
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When the "simple" step
          Then verify
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      PreziAvoidQuotes (Warning) - Avoid using quotes in steps
        lint.feature (4): Test.A step: the "simple" step
        https://prezidoc.atlassian.net/wiki/spaces/WEB/pages/270632203/Gherkin+Linter#GherkinLinter-PreziAvoidQuotes

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
