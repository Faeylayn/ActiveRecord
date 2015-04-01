require_relative 'db_connection'
require_relative 'sql_object'


module Searchable
  def where(params)
    return Relation.new(params, self)
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

class SQLObject
  extend Searchable

end
