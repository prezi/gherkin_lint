Feature: Too Many Tags
  As a Business Analyst
  I want that scenarios are not tagged by too many tags
  so that readers can concentrate on the content of the scenario

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(TooManyTags)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Many Tags
    Given a file named "lint.feature" with:
      """
      @A @B
      Feature: Test
        @C @D @E @F
        Scenario: A
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      TooManyTags (Warning) - Used 6 Tags
        lint.feature (4): Test.A
        https://prezidoc.atlassian.net/wiki/spaces/WEB/pages/270632203/Gherkin+Linter#GherkinLinter-TooManyTags

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      @A
      Feature: Test
        @B
        Scenario: A
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
