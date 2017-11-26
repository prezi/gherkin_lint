@disableUnknownVariable
@disableAvoidQuotes
@disableUseGivenWhenThenOnce
@disableMissingTags
Feature: Avoid characters in the outline

  Background: Prepare Testee

    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(AvoidCharactersInOutlineExample)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Steps With Period
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When <A>
          Then <B>

        Examples: Invalid
          | A | B |
          | a | b |
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      AvoidCharactersInOutlineExample - Better write a scenario
        lint.feature (2): Test.A

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
