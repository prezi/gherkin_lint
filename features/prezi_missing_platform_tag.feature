Feature: Missing tags

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(PreziMissingPlatformTag)
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
      PreziMissingPlatformTag - Missing platform tag
        lint.feature
        https://prezidoc.atlassian.net/wiki/spaces/WEB/pages/270632203/Gherkin+Linter#GherkinLinter-PreziMissingPlatformTag

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
