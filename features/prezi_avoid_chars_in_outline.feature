Feature: Avoid characters in the outline

  Background: Prepare Testee

    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(PreziAvoidCharsInOutline)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Outline containing characters
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When <A>
          Then <B>

        Examples: Invalid
          | A_ | B |
          | a  | b1 |
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      PreziAvoidCharsInOutline (Warning) - Outline example header contains character 'A_'
        lint.feature (2): Test.A
        https://prezidoc.atlassian.net/wiki/spaces/WEB/pages/270632203/Gherkin+Linter#GherkinLinter-PreziAvoidCharsInOutline

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When <A>
          Then <B>

        Examples: Invalid
          | A | B |
          | a | b |
          | c | d |
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
