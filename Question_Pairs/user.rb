require_relative 'questions.rb'

class User
  attr_accessor :fname , :lname
  attr_reader :id

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM users")
    data.map{|user| User.new(user)}
  end

  def self.find_by_id(id)
    user = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    return nil unless user.length>0
    User.new(user.first)
  end

  def self.find_by_name(fname,lname)
    data = QuestionDBConnection.instance.execute(<<-SQL, fname,lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname=?
    SQL
    return nil unless data.length>0
    data.map{|user| User.new(user)}
    # User.new(user.first)
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollows.followed_questions_for_user_id(@id)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end


end
