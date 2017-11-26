Feature: Only one Given, one When and one Then

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(UseGivenWhenThenOnce)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Multiple Givens
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          Given test
          When something
          Then verify
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      UseGivenWhenThenOnce - Multiple Given steps
        lint.feature (2): Test.A

      """

  Scenario: Multiple Actions
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When test
          Then verify
          When something
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      UseGivenWhenThenOnce - Multiple When steps
        lint.feature (2): Test.A

      """

  Scenario: Multiple Thens
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When test
          Then something
          Then verify
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      UseGivenWhenThenOnce - Multiple Then steps
        lint.feature (2): Test.A

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When test
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
