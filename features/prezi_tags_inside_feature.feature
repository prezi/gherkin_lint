Feature: Feature switches at top of file

  Background: Prepare Testee

  Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(PreziTagsInsideFeature)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Tag inside Feature
    Given a file named "lint.feature" with:
      """
      Feature: Test
      @a
      Scenario: A
        When step 1
        Then Step 2
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      PreziTagsInsideFeature - @a not at top of the page
        lint.feature (3): Test.A
        https://prezidoc.atlassian.net/wiki/spaces/WEB/pages/270632203/IN-PROGRESS+Gherkin+Linter#GherkinLinter-PreziTagsInsideFeature

       """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      @enable-fs-C
      Feature: Test
        Scenario: A
          When step 1
          Then Step 2
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
