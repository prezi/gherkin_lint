Feature: Feature switches at top of file

  Background: Prepare Testee

  Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(PreziFeatureSwitchInsideFeature)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Feature switch enabled inside Feature
    Given a file named "lint.feature" with:
      """
      Feature: Test
      @enable-fs-C
      Scenario: A
        When step 1
        Then Step 2
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      PreziFeatureSwitchInsideFeature - @enable-fs-C not enabled/disabled at top of the page
        lint.feature (3): Test.A
        https://prezidoc.atlassian.net/wiki/spaces/WEB/pages/270632203/IN-PROGRESS+Gherkin+Linter#id-[IN-PROGRESS]GherkinLinter-PreziFeatureSwitchInsideFeature

       """

  Scenario: Feature switch enabled inside Feature inside step
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          When enable feature switch
          Then Step 2
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      PreziFeatureSwitchInsideFeature - Avoid enabling/disabling feature switches in steps
        lint.feature (3): Test.A step: enable feature switch
        https://prezidoc.atlassian.net/wiki/spaces/WEB/pages/270632203/IN-PROGRESS+Gherkin+Linter#id-[IN-PROGRESS]GherkinLinter-PreziFeatureSwitchInsideFeature

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
