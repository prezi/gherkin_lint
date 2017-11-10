Feature: Prezi avoid characters in outline example


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

  Scenario: Outline example contains character
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When <A>
          Then something

        Examples: Invalid
          | A |
          | - |
          |   |
          | @ |
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      AvoidCharactersInOutlineExample - Outline example contains character '-'
        lint.feature (2): Test.A
      AvoidCharactersInOutlineExample - Outline example contains character ''
        lint.feature (2): Test.A
      AvoidCharactersInOutlineExample - Outline example contains character '@'
        lint.feature (2): Test.A
      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When <A>
          Then something

        Examples: Invalid
          | A |
          | a |
          | c |
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
