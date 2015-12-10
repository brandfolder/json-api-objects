module JSONAPIonify::Api
  RelationshipNotDefined = Class.new StandardError
  module Resource::RelationshipDefinitions

    def self.extended(klass)
      klass.class_eval do
        extend JSONAPIonify::InheritedAttributes
        inherited_array_attribute :relationship_definitions
      end
    end

    def relates_to_many(name, associate: true, resource: nil, &block)
      define_relationship(name, Relationship::Many, associate: associate, resource: resource, &block)
    end

    def relates_to_one(name, associate: true, resource: nil, &block)
      define_relationship(name, Relationship::One, associate: associate, resource: resource, &block)
    end

    def define_relationship(name, klass, associate: nil, resource: nil, &block)
      const_name = name.to_s.camelcase + 'Relationship'
      remove_const(const_name) if const_defined? const_name
      klass.new(self, name, associate: associate, resource: resource, &block).tap do |new_relationship|
        relationship_definitions.delete new_relationship
        relationship_definitions << new_relationship
      end
    end

    def relationship(name)
      name       = name.to_sym
      const_name = name.to_s.camelcase + 'Relationship'
      return const_get(const_name, false) if const_defined? const_name
      relationship_definition = relationship_definitions.find { |rel| rel.name == name }
      raise RelationshipNotDefined, "Relationship not defined: #{name}" unless relationship_definition
      const_set const_name, relationship_definition.build_class
    end

  end
end
