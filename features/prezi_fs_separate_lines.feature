Feature: Feature switches on separate lines

  Background: Prepare Testee

    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(FSOnSeparateLines)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Steps with feature switches enabled in one line
    Given a file named "lint.feature" with:
      """
      @enable-fs-A @enable-fs-@B @enable-fs-@C
      Feature: Test
        Scenario: A
          When step 1
          Then Step 2
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      FSOnSeparateLines - One feature switch per line
        lint.feature

      """

  Scenario: Steps with feature switches disabled in one line
    Given a file named "lint.feature" with:
      """
      @disable-fs-A @disable-fs-@B @disable-fs-@C
      Feature: Test
        Scenario: A
          When step 1
          Then Step 2
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      FSOnSeparateLines - One feature switch per line
        lint.feature

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      @enable-fs-A
      @enable-fs-B
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
