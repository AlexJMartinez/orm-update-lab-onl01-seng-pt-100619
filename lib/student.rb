require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id


  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end

  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
    end

  def self.create(name, grade)
   student = Student.new(name, grade)
   student.save
  end

  def self.new_from_db(row)
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    self.new(id, name, grade)
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    restult = DB[:conn].execute(sql, name)[0]
    Student.new(restult[0], result[1], result[2])
  end

  def update
  sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
  DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
end
