require "has_crud_for/version"
require "has_crud_for/helpers"
require "active_support/inflector/inflections"
require "active_support/inflector/methods"
require "active_support/inflections"

module HasCrudFor
  DEFAULT_METHODS = [:find, :build, :create, :update, :destroy]

  def has_crud_for(models, options = {})
    methods = begin
      if only = options[:only]
        only
      elsif except = options[:except]
        DEFAULT_METHODS - except
      else
        DEFAULT_METHODS
      end
    end

    name = ActiveSupport::Inflector.singularize((options[:as] || models).to_s)
    if through = options[:through]
      parent = ActiveSupport::Inflector.singularize(through.to_s)
      Helpers.define_crud_through_methods(models, name, parent, methods, self)
    else
      Helpers.define_crud_methods(models, name, methods, self)
    end
  end

end

if defined?(ActiveRecord)
  ActiveRecord::Base.extend(HasCrudFor)
end
