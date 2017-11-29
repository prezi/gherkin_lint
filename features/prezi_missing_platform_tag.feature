Feature: Missing tags

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(MissingPlatformTag)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Missing tags
    Given a file named "lint.feature" with:
      """
      @A
      @B
      Feature: Test
        Scenario: A
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      MissingPlatformTag - Missing platform tag
        lint.feature

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      @desktop
      Feature: Test
        Scenario: A
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
