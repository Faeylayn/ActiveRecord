require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    # ...
    p params
    p params.keys
    set_string = ""
#    set_string = "#{params.keys[0].to_s} = ?"
    params.keys.each do |x|
       set_string += "#{x.to_s} = ? AND "
     end
     set_string = set_string[0..-6]
    p set_string
    p self.class

    results = DBConnection.instance.execute(<<-SQL, params.values)
    SELECT
      *
    FROM
      #{self.table_name}
    WHERE
      #{set_string}
        SQL

    out = self.parse_all(results)

  end
end

class SQLObject
  extend Searchable
  # Mixin Searchable here...
end
