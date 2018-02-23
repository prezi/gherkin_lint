Feature: Missing Scenario Name
  As a Customer
  I want named scenarios
  so that I know what this scenario is about without reading it

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(MissingScenarioName)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Missing Scenario Name
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario:
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      MissingScenarioName - No Scenario Name
        lint.feature (2): Test
        https://prezidoc.atlassian.net/wiki/spaces/WEB/pages/270632203/Gherkin+Linter#GherkinLinter-MissingScenarioName

      """

  Scenario: Missing Scenario Outline Name
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline:
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      MissingScenarioName - No Scenario Name
        lint.feature (2): Test
        https://prezidoc.atlassian.net/wiki/spaces/WEB/pages/270632203/Gherkin+Linter#GherkinLinter-MissingScenarioName

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
