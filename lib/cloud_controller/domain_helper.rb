module CloudController
  module DomainHelper
    DOMAIN_REGEX = /^(([a-z0-9]|[a-z0-9][a-z0-9\-]{0,61}[a-z0-9])\.)+([a-z0-9]|[a-z0-9][a-z0-9\-]{0,61}[a-z0-9])$/ix

    def self.intermediate_domains(name)
      return [] unless name && name =~ DOMAIN_REGEX

      name.split('.').reverse.inject([]) do |array, member|
        array.push(array.empty? ? member : "#{member}.#{array.last}")
      end.drop(1)
    end
  end
end