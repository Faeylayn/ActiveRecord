require_relative 'db_connection'
require 'active_support/inflector'

# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
#  attr_accessor :attributes

  def self.columns
    results = DBConnection.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      #{self.table_name}
    SQL
    output = []
    results.first.keys.each do |key|
      output << key.to_sym
    end
    output.each do |action|
      define_method(action.to_s) do
        attributes[action]
      end
    end
    output.each do |action|
      define_method("#{action}=".to_sym) do |argument|
        attributes[action] = argument
      end
    end
    # ...
  end

  def self.finalize!
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.downcase + 's'
    # ...
  end

  def self.all
    results = DBConnection.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      #{self.table_name}
    SQL

    out = self.parse_all(results)

    # ...
  end

  def self.parse_all(results)
    output = []
    self.columns
    results.each do |result|
      c = self.new(result)
      output << c
    end
    output
    # ...
  end

  def self.find(id)
    output = self.all

    output.each do |thing|

      return thing if thing.attributes[:id] == id
    end
    nil
    # ...
  end

  def initialize(params = {})
    params.keys.each do |param|
      param1 = param.to_sym

      raise "unknown attribute '#{param1}'" unless self.class.columns.include?(param1)
      self.send("#{param}=", params[param])
    end
    # ...
  end

  def attributes
    @attributes ||= {}
    #
  end

  def attribute_values
    @attributes.values
    # ...
  end

  def insert
    vstring = []

    attributes.keys.count.times do |x|
        vstring << '?'
      end
      new_vstring = vstring.join(', ')


    results = DBConnection.instance.execute(<<-SQL, *attribute_values)

      INSERT INTO
      #{self.class.table_name} (#{attributes.keys.join(', ')})

      VALUES
      (#{new_vstring})
    SQL
    self.id = DBConnection.instance.last_insert_row_id

    # ...
  end

  def update
#
  p attribute_values
  p attributes
  value = attribute_values
  value.shift
  p value

    set_string = attributes.keys[1..-1].join(' = ?, ')
    set_string += ' = ?'
    p set_string
     DBConnection.instance.execute(<<-SQL, *value, self.id)
     UPDATE
       #{self.class.table_name}
     SET
       #{set_string}
     WHERE
       id = ?
    SQL
        # ...
  end

  def save
    if id.nil?
      self.insert
    else
      self.update
    end
    # ...
  end

end
