Feature: Missing tags

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(MissingTags)
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
      MissingTags - Missing platform tag
        lint.feature
      MissingTags - Missing team tag
        lint.feature

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      @desktop
      @team-a
      Feature: Test
        Scenario: A
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
