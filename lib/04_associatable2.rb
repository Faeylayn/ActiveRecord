require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)


    define_method(name) do
      through_options = self.class.assoc_options[through_name]

      source_options =
        through_options.model_class.assoc_options[source_name]

      c = through_options.model_class
      key = through_options.send(:foreign_key)
      c_id = through_options.send(:primary_key)
      through = c.where({ c_id => self.send(key) }).first
      s = source_options.model_class
      key_s = source_options.send(:foreign_key)
      c_id_s = source_options.send(:primary_key)
      source = s.where({ c_id_s => through.send(key_s) }).first

    end


    # ...
  end
end
