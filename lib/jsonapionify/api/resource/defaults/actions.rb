module JSONAPIonify::Api
  module Resource::Defaults::Actions
    extend ActiveSupport::Concern

    included do
      before(:create) { |context| context.instance = context.new_instance }
      list
      read
    end
  end
end