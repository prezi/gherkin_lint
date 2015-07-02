require 'gherkin/formatter/json_formatter'
require 'gherkin/parser/parser'
require 'stringio'
require 'multi_json'
require 'term/ansicolor'
include Term::ANSIColor
require 'set'

# gherkin utilities
class GherkinLint
  # entity value class for issues
  class Issue
    attr_reader :name, :references, :description

    def initialize(name, references, description = nil)
      @name = name
      @references = references
      @description = description
    end

    def render
      result = red(@name)
      result += " - #{@description}" unless @description.nil?
      result += "\n  " + green(@references.uniq * "\n  ")
      result
    end
  end

  # base class for all linters
  class Linter
    attr_reader :issues

    def initialize
      @issues = []
      @files = {}
    end

    def features
      @files.each do |file, content|
        content.each do |feature|
          yield(file, feature)
        end
      end
    end

    def files
      @files.keys.each { |file| yield file }
    end

    def scenarios
      @files.each do |file, content|
        content.each do |feature|
          next unless feature.key? 'elements'
          feature['elements'].each do |scenario|
            next if scenario['keyword'] == 'Background'
            yield(file, feature, scenario)
          end
        end
      end
    end

    def backgrounds
      @files.each do |file, content|
        content.each do |feature|
          next unless feature.key? 'elements'
          feature['elements'].each do |scenario|
            next unless scenario['keyword'] == 'Background'
            yield(file, feature, scenario)
          end
        end
      end
    end

    def name
      self.class.name.split('::').last
    end

    def lint_files(files)
      @files = files
      lint
    end

    def lint
      fail 'not implemented'
    end

    def reference(file, feature = nil, scenario = nil, step = nil)
      return file if feature.nil? || feature['name'].empty?
      result = "#{file} (#{line(feature, scenario, step)}): #{feature['name']}"
      result += ".#{scenario['name']}" unless scenario.nil? || scenario['name'].empty?
      result += " step: #{step['name']}" unless step.nil?
      result
    end

    def line(feature, scenario, step)
      line = feature.nil? ? nil : feature['line']
      line = scenario['line'] unless scenario.nil?
      line = step['line'] unless step.nil?
      line
    end

    def add_issue(references, description = nil)
      @issues.push Issue.new(name, references, description)
    end
  end

  # service class to lint for unique scenario names
  class UniqueScenarioNames < Linter
    def lint
      references_by_name = Hash.new []
      scenarios do |file, feature, scenario|
        next unless scenario.key? 'name'
        scenario_name = "#{feature['name']}.#{scenario['name']}"
        references_by_name[scenario_name] = references_by_name[scenario_name] + [reference(file, feature, scenario)]
      end
      references_by_name.each do |name, references|
        next if references.length <= 1
        add_issue(references, "'#{name}' used #{references.length} times")
      end
    end
  end

  # service class to lint for missing test actions
  class MissingTestAction < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.key? 'steps'
        when_steps = scenario['steps'].select { |step| step['keyword'] == 'When ' }
        next if when_steps.length > 0
        references = [reference(file, feature, scenario)]
        add_issue(references, 'No \'When\'-Step')
      end
    end
  end

  # service class to lint for missing verifications
  class MissingVerification < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.key? 'steps'
        then_steps = scenario['steps'].select { |step| step['keyword'] == 'Then ' }
        next if then_steps.length > 0
        references = [reference(file, feature, scenario)]
        add_issue(references, 'No verification step')
      end
    end
  end

  # service class to lint for backgrond that does more than setup
  class BackgroundDoesMoreThanSetup < Linter
    def lint
      backgrounds do |file, feature, background|
        next unless background.key? 'steps'
        invalid_steps = background['steps'].select { |step| step['keyword'] == 'When ' || step['keyword'] == 'Then ' }
        next if invalid_steps.empty?
        references = [reference(file, feature, background, invalid_steps[0])]
        add_issue(references, 'Just Given Steps allowed')
      end
    end
  end

  # service class to lint for missing feature names
  class MissingFeatureName < Linter
    def lint
      features do |file, feature|
        name = feature.key?('name') ? feature['name'].strip : ''
        next unless name.empty?
        references = [reference(file, feature)]
        add_issue(references, 'No Feature Name')
      end
    end
  end

  # service class to lint for missing feature descriptions
  class MissingFeatureDescription < Linter
    def lint
      features do |file, feature|
        name = feature.key?('description') ? feature['description'].strip : ''
        next unless name.empty?
        references = [reference(file, feature)]
        add_issue(references, 'Favor a user story as description')
      end
    end
  end

  # service class to lint for missing scenario names
  class MissingScenarioName < Linter
    def lint
      scenarios do |file, feature, scenario|
        name = scenario.key?('name') ? scenario['name'].strip : ''
        references = [reference(file, feature, scenario)]
        next unless name.empty?
        add_issue(references, 'No Scenario Name')
      end
    end
  end

  # service class to lint for missing example names
  class MissingExampleName < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.key? 'examples'
        scenario['examples'].each do |example|
          name = example.key?('name') ? example['name'].strip : ''
          next unless name.empty?
          references = [reference(file, feature, scenario)]
          add_issue(references, 'No Example Name')
        end
      end
    end
  end

  # service class to lint for invalid step flow
  class InvalidStepFlow < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.key? 'steps'
        steps = scenario['steps'].select { |step| step['keyword'] != 'And ' && step['keyword'] != 'But ' }
        last_step_is_an_action(file, feature, scenario, steps)
        given_after_non_given(file, feature, scenario, steps)
        verification_before_action(file, feature, scenario, steps)
      end
    end

    def last_step_is_an_action(file, feature, scenario, steps)
      references = [reference(file, feature, scenario, steps.last)]
      add_issue(references, 'Last step is an action') if steps.last['keyword'] == 'When '
    end

    def given_after_non_given(file, feature, scenario, steps)
      last_step = steps.first
      steps.each do |step|
        references = [reference(file, feature, scenario, step)]
        description = 'Given after Action or Verification'
        add_issue(references, description) if step['keyword'] == 'Given ' && last_step['keyword'] != 'Given '
        last_step = step
      end
    end

    def verification_before_action(file, feature, scenario, steps)
      steps.each do |step|
        break if step['keyword'] == 'When '
        references = [reference(file, feature, scenario, step)]
        description = 'Verification before action'
        add_issue(references, description) if step['keyword'] == 'Then '
      end
    end
  end

  # service class to lint for invalid scenario names
  class InvalidScenarioName < Linter
    def lint
      scenarios do |file, feature, scenario|
        next if scenario['name'].empty?
        references = [reference(file, feature, scenario)]
        description = 'Prefer to rely just on Given and When steps when name your scenario to keep it stable'
        bad_words = %w(test verif check)
        bad_words.each do |bad_word|
          add_issue(references, description) if scenario['name'].downcase.include? bad_word
        end
      end
    end
  end

  # service class to lint for invalid file names
  class InvalidFileName < Linter
    def lint
      files do |file|
        base = File.basename file
        next if base == base.downcase
        references = [reference(file)]
        add_issue(references, 'Feature files should be snake_cased')
      end
    end
  end

  # service class to lint for unused variables
  class UnusedVariable < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.key? 'examples'
        scenario['examples'].each do |example|
          next unless example.key? 'rows'
          example['rows'].first['cells'].each do |variable|
            references = [reference(file, feature, scenario)]
            add_issue(references, "'<#{variable}>' is unused") unless used?(variable, scenario)
          end
        end
      end
    end

    def used?(variable, scenario)
      variable = "<#{variable}>"
      return false unless scenario.key? 'steps'
      scenario['steps'].each do |step|
        return true if step['name'].include? variable
        return true if used_in_docstring?(variable, step)
        return true if used_in_table?(variable, step)
      end
      false
    end

    def used_in_docstring?(variable, step)
      step.key?('doc_string') && step['doc_string']['value'].include?(variable)
    end

    def used_in_table?(variable, step)
      return false unless step.key? 'rows'
      step['rows'].each do |row|
        row['cells'].each { |value| return true if value.include?(variable) }
      end
      false
    end
  end

  # service class to lint for avoiding colons
  class AvoidColon < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.key? 'steps'

        scenario['steps'].each do |step|
          references = [reference(file, feature, scenario, step)]
          add_issue(references) if step['name'].strip.end_with? '.'
        end
      end
    end
  end

  LINTER = [
    AvoidColon,
    BackgroundDoesMoreThanSetup,
    MissingExampleName,
    MissingFeatureDescription,
    MissingFeatureName,
    MissingScenarioName,
    MissingTestAction,
    MissingVerification,
    InvalidFileName,
    InvalidScenarioName,
    InvalidStepFlow,
    UniqueScenarioNames,
    UnusedVariable
  ]

  def initialize
    @files = {}
    @linter = []
    enable_all
  end

  def enable_all
    disable []
  end

  def enable(enabled_linter)
    @linter = []
    enabled_linter = Set.new enabled_linter
    LINTER.each do |linter|
      new_linter = linter.new
      next unless enabled_linter.include? new_linter.class.name.split('::').last
      register_linter new_linter
    end
  end

  def disable(disabled_linter)
    @linter = []
    disabled_linter = Set.new disabled_linter
    LINTER.each do |linter|
      new_linter = linter.new
      next if disabled_linter.include? new_linter.class.name.split('::').last
      register_linter new_linter
    end
  end

  def register_linter(linter)
    @linter.push linter
  end

  def analyze(file)
    @files[file] = parse file
  end

  def parse(file)
    content = File.read file
    # puts to_json(content, file)
    to_json(content, file)
  end

  def report
    issues = @linter.map do |linter|
      linter.lint_files @files
      linter.issues
    end.flatten

    issues.each { |issue| puts issue.render }
    return 0 if issues.length == 0
    -1
  end

  def to_json(input, file = 'generated.feature')
    io = StringIO.new
    formatter = Gherkin::Formatter::JSONFormatter.new(io)
    parser = Gherkin::Parser::Parser.new(formatter, true)
    parser.parse(input, file, 0)
    formatter.done
    MultiJson.load io.string
  end

  def print(issues)
    puts "There are #{issues.length} Issues" unless issues.empty?
    issues.each { |issue| puts issue }
  end
end