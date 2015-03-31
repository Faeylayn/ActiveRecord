require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    # ...
  end

  def table_name
    # ...
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] || "#{name}_id".to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || name.slice(0,1).capitalize + name.slice(1..-1)

  end

  def model_class
    @class_name.constantize
  end

  def table_name
    @class_name.downcase + 's'
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] || "#{self_class_name}_id".downcase.to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || name.slice(0,1).capitalize + name.slice(1..-2)

  end

  def model_class
    @class_name.constantize
  end

  def table_name
    @class_name.downcase + 's'
  end

end

module Associatable
  def belongs_to(name, option = {})
    options = BelongsToOptions.new(name, option)
    assoc_options[name] = options
    define_method(name) do
      c = options.model_class
      key = options.send(:foreign_key)
      c_id = options.send(:primary_key)
      results = c.where({ c_id => self.send(key) })
      results.first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self,  options)
    define_method(name) do
      c = options.model_class
      key = options.send(:foreign_key)
      c_id = options.send(:primary_key)
      results = c.where({ key => self.send(c_id) })
      results
    end
  end

  def assoc_options
      @assoc_options ||= {}
  end


end

class SQLObject

  extend Associatable

end
