require 'term/ansicolor'

module GherkinLint
  # entity value class for issues
  class Issue
    include Term::ANSIColor
    attr_reader :name, :references, :description

    def initialize(name, references, description = nil)
      @name = name
      @references = references
      @description = description
      @link = 'https://prezidoc.atlassian.net/wiki/spaces/WEB/pages/270632203/Gherkin+Linter#GherkinLinter-'
    end
  end

  # entity value class for errors
  class Error < Issue
    def render
      result = red(@name)
      result += " - #{@description}" unless @description.nil?
      result += "\n  " + green(@references.uniq * "\n  ")
      result += "\n  " + @link + @name
      result
    end
  end

  # entity value class for warnings
  class Warning < Issue
    def render
      result = "#{yellow(@name)} (Warning)"
      result += " - #{@description}" unless @description.nil?
      result += "\n  " + green(@references.uniq * "\n  ")
      result += "\n  " + @link + @name
      result
    end
  end
end
