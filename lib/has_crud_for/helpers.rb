module HasCrudFor
  module Helpers
    extend self

    def define_crud_methods(models, name, methods = [], klass)
      klass.send(:define_method, "find_#{name}".to_sym) do |id|
        send(models).find(id)
      end if methods.include?(:find)

      klass.send(:define_method, "build_#{name}".to_sym) do |hash = {}|
        send(models).build(hash)
      end if methods.include?(:build)

      klass.send(:define_method, "create_#{name}".to_sym) do |hash = {}|
        send(models).create(hash)
      end if methods.include?(:create)

      klass.send(:define_method, "create_#{name}!".to_sym) do |hash = {}|
        send(models).create!(hash)
      end if methods.include?(:create)

      klass.send(:define_method, "update_#{name}".to_sym) do |id, hash|
        send(models).update(id, hash)
      end if methods.include?(:update)

      klass.send(:define_method, "destroy_#{name}".to_sym) do |id|
        send(models).destroy(id)
      end if methods.include?(:destroy)
    end

    def define_crud_through_methods(models, name, parent, methods = [], klass)
      model_name = ActiveSupport::Inflector.singularize(models.to_s)

      klass.send(:define_method, "find_#{name}".to_sym) do |parent_id, id|
        send("find_#{parent}", parent_id).send("find_#{model_name}", id)
      end if methods.include?(:find)

      klass.send(:define_method, "build_#{name}".to_sym) do |parent_id, hash = {}|
        send("find_#{parent}", parent_id).send("build_#{model_name}", hash)
      end if methods.include?(:build)

      klass.send(:define_method, "create_#{name}".to_sym) do |parent_id, hash = {}|
        send("find_#{parent}", parent_id).send("create_#{model_name}", hash)
      end if methods.include?(:create)

      klass.send(:define_method, "create_#{name}!".to_sym) do |parent_id, hash = {}|
        send("find_#{parent}", parent_id).send("create_#{model_name}!", hash)
      end if methods.include?(:create)

      klass.send(:define_method, "update_#{name}".to_sym) do |parent_id, id, hash|
        send("find_#{parent}", parent_id).send("update_#{model_name}", id, hash)
      end if methods.include?(:update)

      klass.send(:define_method, "destroy_#{name}".to_sym) do |parent_id, id|
        send("find_#{parent}", parent_id).send("destroy_#{model_name}", id)
      end if methods.include?(:destroy)
    end
  end
end
