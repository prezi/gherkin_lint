Feature: Feature switches on separate lines

  Background: Prepare Testee

    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(PreziFSOnSeparateLines)
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
      PreziFSOnSeparateLines - One feature switch per line
        lint.feature
        https://prezidoc.atlassian.net/wiki/spaces/WEB/pages/270632203/IN-PROGRESS+Gherkin+Linter#GherkinLinter-PreziFSOnSeparateLines

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
      PreziFSOnSeparateLines - One feature switch per line
        lint.feature
        https://prezidoc.atlassian.net/wiki/spaces/WEB/pages/270632203/IN-PROGRESS+Gherkin+Linter#GherkinLinter-PreziFSOnSeparateLines

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
