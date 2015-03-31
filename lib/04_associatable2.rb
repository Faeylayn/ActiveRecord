require_relative '03_associatable'


module Associatable
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
  end
end


class Relation

  def initialize(params, origin)
    @params = params
    @origin = origin
    @set_string = ""
    where(@params)
  end


  def where(params)
    params.keys.each do |x|
       @set_string += "#{x.to_s} = ? AND "
     end
     @set_string = @set_string[0..-6]

     return self
  end

  def method_missing(method, *args)
    results = DBConnection.instance.execute(<<-SQL, @params.values)
    SELECT
      *
    FROM
      #{@origin.table_name}
    WHERE
      #{@set_string}
        SQL

    out = @origin.parse_all(results)
    out.send(method, *args)

  end

  def inspect
    method_missing(:inspect)
  end

end
