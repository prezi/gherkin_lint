Feature: Feature switches at top of file

  Background: Prepare Testee

  Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(TagsInsideFeature)
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
      TagsInsideFeature - @a not at top of the page
        lint.feature (3): Test.A

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
