require 'byebug'
require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    @arr ||= fetch_columns
  end

  def self.fetch_columns
    arr = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        cats
      LIMIT 0
    SQL
    arr.flatten.map(&:to_sym)
  end

  def self.finalize!

    self.columns.each do |col|
      define_method("#{col}") do
        attributes[col]
      end
    end

    self.columns.each do |col|
      define_method("#{col}=") do |el|
        attributes[col] = el
      end
    end

  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= "#{self}s".downcase
  end

  def self.all
    results = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        cats
      WHERE
        id != 1
    SQL

    self.parse_all(results)
  end

  def self.parse_all(results)
    results.map do |row|
      self.new(row)
    end
  end

  def self.find(id)
    results =  DBConnection.execute2(<<-SQL, id)
      SELECT
        '#{@table_name}'.*
      FROM
        '#{@table_name}'
      WHERE
        '#{@table_name}'.id = ?
    SQL

    parse_all(results).first


    # results = DBConnection.execute(<<-SQL, id)
    #   SELECT
    #     #{table_name}.*
    #   FROM
    #     #{table_name}
    #   WHERE
    #     #{table_name}.id = ?
    # SQL
    #
    # parse_all(results).first


  end

  def initialize(params = {})
    params.each do |key,value|
      key = key.to_sym
      raise "unknown attribute '#{key.to_s}'" unless SQLObject.columns.include?(key)
      self.send "#{key}=", value
    end

  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
