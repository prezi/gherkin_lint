module GherkinLint
  # Mixin to lint for tags based on their relationship to eachother
  module TagCollector
    def gather_tags(element)
      return {} unless element.include? :tags
      element[:tags].map { |tag| tag[:name][1..-1] unless tag[:name].include? '-fs' }.compact
    end

    def gather_fs(element)
      return {} unless element.include? :tags
      element[:tags].map { |tag| tag[:name][1..-1] if tag[:name].include? '-fs' }.compact
    end

    def gather_tag_locations(element)
      return {} unless element.include? :tags
      element[:tags].map { |tag| _get_tag_dict(tag) unless tag[:name].include? '-fs' }.compact
    end

    def gather_fs_locations(element)
      return {} unless element.include? :tags
      element[:tags].map { |tag| _get_tag_dict(tag) if tag[:name].include? '-fs' }.compact
    end

    def _get_tag_dict(tag)
      { name: tag[:name][1..-1], location: tag[:location][:line] }
    end
  end
end
