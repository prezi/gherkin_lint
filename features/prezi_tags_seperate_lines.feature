Feature: Tags on separate lines

  Background: Prepare Testee

    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(TagsOnSeperateLines)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Steps With Period
    Given a file named "lint.feature" with:
      """
      @A @B @C
      Feature: Test
        Scenario: A
          When step 1
          Then Step 2
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      TagsOnSeperateLines - One tag per line
        lint.feature

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      @A
      @B
      @C
      Feature: Test
        Scenario: A
          When step 1
          Then Step 2
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
