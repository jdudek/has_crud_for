require "has_crud_for/version"
require "active_support/core_ext/string/inflections"
require 'active_support/core_ext/module/introspection'

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

    name = (options[:as] || models).to_s.singularize
    if through = options[:through]
      parent = through.to_s.singularize
      define_crud_through_methods(models, name, parent, methods)
    else
      define_crud_methods(models, name, methods)
    end
  end

  private

  def define_crud_methods(models, name, methods = [])
    define_method "find_#{name}".to_sym do |id|
      send(models).find(id)
    end if methods.include?(:find)

    define_method "build_#{name}".to_sym do |hash = {}|
      send(models).build(hash)
    end if methods.include?(:build)

    define_method "create_#{name}".to_sym do |hash = {}|
      send(models).create(hash)
    end if methods.include?(:create)

    define_method "create_#{name}!".to_sym do |hash = {}|
      send(models).create!(hash)
    end if methods.include?(:create)

    define_method "update_#{name}".to_sym do |id, hash|
      send(models).update(id, hash)
    end if methods.include?(:update)

    define_method "destroy_#{name}".to_sym do |id|
      send(models).destroy(id)
    end if methods.include?(:destroy)
  end

  def define_crud_through_methods(models, name, parent, methods = [])
    model_name = models.to_s.singularize

    define_method "find_#{name}".to_sym do |parent_id, id|
      send("find_#{parent}", parent_id).send("find_#{model_name}", id)
    end if methods.include?(:find)

    define_method "build_#{name}".to_sym do |parent_id, hash = {}|
      send("find_#{parent}", parent_id).send("build_#{model_name}", hash)
    end if methods.include?(:build)

    define_method "create_#{name}".to_sym do |parent_id, hash = {}|
      send("find_#{parent}", parent_id).send("create_#{model_name}", hash)
    end if methods.include?(:create)

    define_method "create_#{name}!".to_sym do |parent_id, hash = {}|
      send("find_#{parent}", parent_id).send("create_#{model_name}!", hash)
    end if methods.include?(:create)

    define_method "update_#{name}".to_sym do |parent_id, id, hash|
      send("find_#{parent}", parent_id).send("update_#{model_name}", id, hash)
    end if methods.include?(:update)

    define_method "destroy_#{name}".to_sym do |parent_id, id|
      send("find_#{parent}", parent_id).send("destroy_#{model_name}", id)
    end if methods.include?(:destroy)
  end
end
