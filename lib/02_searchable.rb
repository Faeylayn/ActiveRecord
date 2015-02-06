require_relative 'db_connection'
require_relative '01_sql_object'
require_relative '04_associatable2'

module Searchable
  def where(params)
    # ...
    return Relation.new(params, self)


  end
end

class SQLObject
  extend Searchable
  # Mixin Searchable here...
end
