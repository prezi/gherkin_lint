Feature: Precedence
  As a User
  I want to be able to turn linters of and on with configuration and CLI
  so that it's easier to enable and disable linters

  Scenario: Disable With local override
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """
    And a file named ".gherkin_lint.yml" with:
      """
      ---
      MissingPlatformTag:
          Enabled: false
      """
    And a file named "lint.feature" with:
      """
      @team-a

      Feature: Lint
        A User can test a feature
        Scenario: A
          Given this is a setup
          When I run the test
          Then it gets verified
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """

  Scenario: Disable on local, Enable on CLI
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
    And a file named ".gherkin_lint.yml" with:
      """
      ---
      MissingPlatformTag:
          Enabled: false
      """
    And a file named "lint.feature" with:
      """
      @team-a

      Feature: Lint
        A User can test a feature
        Scenario: A
          Given this is a setup
          When I run the test
          Then it gets verified
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      MissingPlatformTag - Missing platform tag
        lint.feature

      """
