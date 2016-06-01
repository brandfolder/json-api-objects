module JSONAPIonify::Api
  module Action::Documentation
    def documentation_object(base, resource, name, include_path, label)
      url  = build_path(base, name.to_s, include_path)
      path = URI.parse(url).path
      OpenStruct.new(
        id:              [request_method, path].join('-').parameterize,
        label:           label,
        sample_requests: example_requests(resource, url)
      )
    end

    def example_input(resource)
      request = Server::Request.env_for('http://example.org', request_method)
      context = resource.new(
        request: request,
        context_definitions: sample_context(resource)
      ).exec { |c| c }
      case @example_input
      when :resource
        {
          'data' => resource.build_resource(
            context: context,
            instance: resource.example_instance_for_action(name, context),
            links:         false
          ).as_json
        }.to_json
      when :resource_identifier
        {
          'data' => resource.build_resource_identifier(
            instance: resource.example_instance_for_action(name, context)
          ).as_json
        }.to_json
      when Proc
        @example_input.call
      end
    end

    def example_requests(resource, url)
      responses.map do |response|
        opts                 = {}
        opts['CONTENT_TYPE'] = content_type if @example_input
        accept = response.accept || response.example_accept
        opts['HTTP_ACCEPT']   = accept
        if content_type == 'application/vnd.api+json' && @example_input
          opts[:input] = example_input(resource)
        end
        url = "#{url}.#{response.extension}" if response.extension
        request  = Server::Request.env_for(url, request_method, opts)
        response = Server::MockResponse.new(*sample_request(resource, request))

        OpenStruct.new(
          request:  request.http_string,
          response: response.http_string
        )
      end
    end

    def sample_context(resource)
      resource.context_definitions.dup.tap do |defs|
        collection_context          = proc do |context|
          3.times.map { resource.example_instance_for_action(action.name, context) }
        end
        defs[:_is_example_]         = Context.new(readonly: true) { true }
        defs[:collection]           = Context.new(&collection_context)
        defs[:paginated_collection] = Context.new { |context| context.collection }
        defs[:instance]             = Context.new(readonly: true) { |context| context.collection.first }
        defs[:owner_context]        = Context.new(readonly: true) { ContextDelegate::Mock.new } if defs.has_key? :owner_context
      end
    end

    def sample_request(resource, request)
      call(resource, request, context_definitions: sample_context(resource), callbacks: false)
    end
  end
end