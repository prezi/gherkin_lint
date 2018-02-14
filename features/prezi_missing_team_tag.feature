Feature: Missing tags

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(PreziMissingTeamTag)
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
      PreziMissingTeamTag - Missing team tag
        lint.feature
        https://prezidoc.atlassian.net/wiki/spaces/WEB/pages/270632203/IN-PROGRESS+Gherkin+Linter#id-[IN-PROGRESS]GherkinLinter-PreziMissingTeamTag

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      @team-a
      Feature: Test
        Scenario: A
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
