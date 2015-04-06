class Converter
  def initialize(sqlsyntax)
    @sqlsyntax = sqlsyntax
    @active_record_syntax = []
  end

  SqlDatatypeToActiveRecordDatatype = {
    'INTEGER' =>  'integer',
    'TINYINT' =>  'integer',
    'SMALLINT' =>  'integer',
    'MEDIUMINT' =>  'integer',
    'INT' =>  'integer',
    'BIGINT' =>  'integer',
    'DECIMAL' =>  'decimal',
    'FLOAT' =>  'float',
    'DOUBLE' =>  '',
    'CHAR' => 'string',
    'VARCHAR' => 'string',
    'MEDIUMTEXT' =>  'text',
    'BINARY' =>  'binary',
    'VARBINARY' =>  '',
    'BLOB' =>  '',
    'DATE' =>  'date',
    'TIME' =>  'time',
    'DATETIME' => 'datetime',
    'YEAR' =>  '',
    'TIMESTAMP' =>  'timestamp',
    'ENUM' =>  'boolean',
    'SET' =>  'boolean',
    'bit' => 'boolean'
  }

  def convert_output
    remove_useless
    remove_sql_line_options
    delete_primary_key
    convert_to_symbol
    create_end
    converting_data_type
    add_ruby_block
    @active_record_syntax.map! do |line|
      line.join(' ')
    end
    @active_record_syntax
  end
 #Cleaning everything not related to table creation
  def remove_useless
    @sqlsyntax.split("\r\n").each do |line|
      @active_record_syntax << line.split(' ') if line.start_with?('CREATE TABLE','  `',');')
    end
  end

 #table collumn option delete.(todo SQL option to ActiveRecord option)
# utilise la method reject pour refactor ca 
  def remove_sql_line_options
    @active_record_syntax.each do |line|
      line.delete('(')
      line.delete('AUTO_INCREMENT')
      line.delete('TABLE')
      line.delete('NULL')
      line.delete('NULL,')
      line.delete('DEFAULT')
    end
    puts "_______________________"
    p @active_record_syntax
  end

  def delete_primary_key
  @active_record_syntax.delete_if {|x| x.include?('`id`') }
  end

  def convert_to_symbol
    @active_record_syntax.each do |line|
      line.map! do |line_word|
        if line_word.start_with?('`')
          line_word.delete!('`')
          ':' + line_word
        else
          line_word
        end
      end
    end
  end

  def create_end
    @active_record_syntax.each do |line|
      line.map! do |line_word|
        if line_word.start_with?('CREATE')
          line_word.delete!('CREATE')
          'create_table'
        elsif line_word.start_with?(');')
          'end'
        else
          line_word
        end
      end
    end
  end

  def converting_data_type
    @active_record_syntax.each do |line|
 #Converting datatype and repositionning the col :name.
      line[0],line[1] = 't.' + Converter::SqlDatatypeToActiveRecordDatatype[line[1]], line[0]  if (line & ['CHAR', 'INTEGER', 'TINYINT', 'SMALLINT', 'MEDIUMINT', 'INT' 'BIGINT', 'DECIMAL', 'FLOAT', 'DOUBLE', 'CHAR', 'VARCHAR', 'MEDIUMTElineT', 'BINARY', 'VARBINARY', 'BLOB', 'DATE', 'TIME', 'DATETIME', 'YEAR', 'TIMESTAMP', 'ENUM', 'SET', 'bit']).length != 0
      @active_record_syntax
    end
  end

  def add_ruby_block
    @active_record_syntax.each do |line|
      if line.include?('create_table')
        line.push('do')
        line.push('|t|')
      end
    end
  end
end
