class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.mass_initialization_from_db(sql)
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.student_sql_search(string_to_append = "")
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    sql + string_to_append
  end

  def self.all
    sql = student_sql_search
    mass_initialization_from_db(sql)
  end

  def self.all_students_in_grade_9
    all_students_in_grade_X(9)
  end
  
  def self.students_below_12th_grade
    sql = student_sql_search('WHERE grade <= 11')
    mass_initialization_from_db(sql)
  end

  def self.first_X_students_in_grade_10(x)
    sql = student_sql_search("WHERE grade = 10 LIMIT #{x}")
    
    mass_initialization_from_db(sql)
  end

  def self.first_student_in_grade_10
    first_X_students_in_grade_10(1).first
  end

  def self.all_students_in_grade_X(x)
    sql = student_sql_search("WHERE grade = #{x}")
      
    mass_initialization_from_db(sql)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
