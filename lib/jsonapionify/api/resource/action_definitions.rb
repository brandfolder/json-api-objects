require 'active_support/core_ext/array/wrap'

module JSONAPIonify::Api
  module Resource::ActionDefinitions
    def self.extended(klass)
      klass.class_eval do
        extend JSONAPIonify::InheritedAttributes
        inherited_array_attribute :action_definitions
      end
    end

    def index(**options, &block)
      define_action(:index, **options, &block).response status: 200 do |context|
        context.response_object[:data] = build_collection(context.request, context.paginated_collection, fields: context.fields)
        context.meta[:total_count]     = context.collection.count
        context.response_object.to_json
      end
    end

    def create(**options, &block)
      define_action(:create, **options) do |context|
        context.instance = context.new_instance
        instance_exec(context, &block)
      end.response status: 201 do |context|
        context.response_object[:data] = build_resource(context.request, context.instance, fields: context.fields)
        context.response_object.to_json
      end
    end

    def read(**options, &block)
      define_action(:read, **options, &block).response status: 200 do |context|
        context.response_object[:data] = build_resource(context.request, context.instance, fields: context.fields)
        context.response_object.to_json
      end
    end

    def update(**options, &block)
      define_action(:update, **options, &block).response status: 200 do |context|
        context.response_object[:data] = build_resource(context.request, context.instance, fields: context.fields)
        context.response_object.to_json
      end
    end

    def delete(**options, &block)
      define_action(:delete, **options, &block).response status: 204
    end

    def process(action_name, request)
      find_supported_action(action_name, request).call(self, request)
    end

    private

    def define_action(name, content_type: nil, &block)
      Action.new(name, content_type: content_type, &block).tap do |new_action|
        remove_action name, content_type: content_type
        action_definitions << new_action
      end
    end

    def find_supported_action(action_name, request)
      action_definitions.find do |action_definition|
        action_definition.name == action_name && action_definition.supports?(request)
      end || Action::NotFound
    end

    def remove_action(*names)
      action_definitions.delete_if do |action_defintion|
        names.include? action_defintion.name
      end
    end
  end
end