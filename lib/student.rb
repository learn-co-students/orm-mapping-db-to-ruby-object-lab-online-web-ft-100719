class Student
  attr_accessor :id, :name, :grade
  @@all = []

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    #@@all << new_student
    
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
    SQL
 
    DB[:conn].execute(sql).map do |row|
	    self.new_from_db(row)
	  end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class

    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?

    SQL

    new_student = DB[:conn].execute(sql, name)[0]
    
    new_student1 = self.new_from_db(new_student)
    

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

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 9
    
    SQL

    answer = DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade < 12
    
    SQL

    answer = DB[:conn].execute(sql)
    new_student1 = self.new_from_db(answer[0])
    answer1 = [new_student1]
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      ORDER BY id ASC LIMIT ?
    SQL
    answer = DB[:conn].execute(sql, x)
    
    #now build instance on each and return an array
    answer1 = answer.map do |row|
      self.new_from_db(row)
    end
    answer1
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      ORDER BY id ASC LIMIT 1
    SQL
    answer = DB[:conn].execute(sql)
    new_student1 = self.new_from_db(answer[0])

  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
      
    SQL
    answer = DB[:conn].execute(sql, x)
    answer1 = answer.map do |row|
      self.new_from_db(row)
    end
    answer1
  end




end
