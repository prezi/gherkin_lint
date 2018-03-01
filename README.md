# Lint Gherkin Files

This tool lints gherkin files. It is customized to lint rules set in the [Prezi Cucumber Standards](https://prezidoc.atlassian.net/wiki/spaces/WEB/pages/133623836/Cucumber+Standards).

Find a detailed description, default value and example of all rules available in the [Prezi Gherkin Linter document](https://prezidoc.atlassian.net/wiki/spaces/WEB/pages/270632203/Gherkin+Linter+for+Cucumber).

## Test gem locally

run `rake test`

## Build gem

run `rake build` which creates gherkin_lint-1.1.0.gem file

## Install gem

run `gem install gherkin_lint-1.1.0.gem`

## Usage

run `gherkin_lint` on a list of files

    gherkin_lint -f '<wild_card_path>' #default is `features/**/*.feature`

With `--disable CHECK` or `--enable CHECK` it's possible to disable respectivly enable program wide checks except when a linter requires additional values to be set in order to be valid.  Currently only RequiredTagStartsWith meets this criteria. 

## Checks

- [AvoidOutlineForSingleExample: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/avoid_outline_for_single_example.feature)
- [AvoidPeriod: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/avoid_period.feature)
- [AvoidScripting: Disabled](https://github.com/prezi/gherkin_lint/blob/master/features/avoid_scripting.feature)
- [BackgroundDoesMoreThanSetup: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/background_does_more_than_setup.feature)
- [BackgroundRequiresMultipleScenarios: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/background_requires_scenario.feature)
- [BadScenarioName: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/bad_scenario_name.feature)
- [BeDeclarative: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/be_declarative.feature)
- [FileNameDiffersFeatureName: Disabled](https://github.com/prezi/gherkin_lint/blob/master/features/file_name_differs_feature_name.feature)
- [MissingExampleName: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/invalid_file_name.feature)
- [MissingFeatureDescription: Disabled](https://github.com/prezi/gherkin_lint/blob/master/features/invalid_step_flow.feature)
- [MissingFeatureName: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/missing_example_name.feature)
- [MissingScenarioName: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/missing_feature_description.feature)
- [MissingTestAction: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/missing_feature_name.feature)
- [MissingVerification: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/missing_scenario_name.feature)
- [InvalidFileName: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/missing_test_action.feature)
- [InvalidStepFlow: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/missing_verification.feature)
- [RequiredTagsStartsWith: Disabled](https://github.com/prezi/gherkin_lint/blob/master/features/required_tags_starts_with.feature)
- [SameTagForAllScenarios: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/same_tag_for_all_scenarios.feature)
- [TagUsedMultipleTimes: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/tag_used_multiple_times.feature)
- [TooClumsy: Disabled](https://github.com/prezi/gherkin_lint/blob/master/features/too_clumsy.feature)
- [TooManyDifferentTags: Disabled](https://github.com/prezi/gherkin_lint/blob/master/features/too_long_step.feature)
- [TooManySteps: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/too_many_different_tags.feature)
- [TooManyTags: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/too_many_steps.feature)
- [TooLongStep: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/too_many_tags.feature)
- [UniqueScenarioNames: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/unique_scenario_names.feature)
- [UnknownVariable: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/unknown_variable.feature)
- [UnusedVariable: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/unused_variable.feature)
- [UseBackground: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/use_background.feature)
- [UseOutline: Disabled](https://github.com/prezi/gherkin_lint/blob/master/features/use_outline.feature)


## Custom Checks

- [PreziAvoidCharsInOutline: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/prezi_avoid_chars_in_outline.feature)
- [PreziAvoidQuotes: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/prezi_avoid_quotes.feature)
- [PreziAvoidStepsContaining: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/prezi_avoid_steps_containing.feature)
- [PreziFeatureSwitchInsideFeature: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/prezi_fs_inside_feature.feature)
- [PreziFSOnSeparateLines: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/prezi_fs_on_separate_lines.feature)
- [PreziMissingPlatformTag: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/prezi_missing_platform_tag.feature)
- [PreziMissingTeamTag:   Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/prezi_missing_team_tag.feature)
- [PreziTagsFeatureSwitchOrder: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/prezi_tags_fs_order.feature)
- [PreziTagsInsideFeature: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/prezi_tags_inside_feature.feature)
- [PreziTagsOnSeparateLines: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/prezi_tags_on_separate_lines.feature)
- [PreziUseGivenWhenThenOnce: Enabled](https://github.com/prezi/gherkin_lint/blob/master/features/prezi_use_given_when_then_once.feature)

## Errors and Warnings

There are errors and warnings.

### Warnings

Warnings are for issues that do not influence the returncode. These issues are also for introducing new checks.
These new checks will stay some releases as warning and will be later declared as error, to give users the possibility to adapt their codebase.

### Errors

If there is at least one error, the returncode will be set to ERROR (!= 0).
