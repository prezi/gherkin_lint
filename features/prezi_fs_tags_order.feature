Feature: Tags before feature switches

  Background: Prepare Testee

    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(TagsFeatureSwitchOrder)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Feature switch enabled before tags
    Given a file named "lint.feature" with:
      """
      @enable-fs-C
      @A
      @B
      Feature: Test
        Scenario: A
          When step 1
          Then Step 2
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      TagsFeatureSwitchOrder - @enable-fs-C not enabled/disabled after tags
        lint.feature (5): Test.A

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      @A
      @B
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
