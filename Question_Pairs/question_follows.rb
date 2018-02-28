require_relative 'questions.rb'

class QuestionFollows
  attr_accessor :question_id, :user_id

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM question_follows")
    data.map{|q| QuestionFollows.new(q)}
  end

  def self.find_by_id(id)
    question = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    return nil unless question.length>0
    QuestionFollows.new(question.first)
  end

  def self.followers_for_question_id(question_id)
    #This will return an array of User objects!
    data = QuestionDBConnection.instance.execute(<<-SQL,question_id)
      SELECT
        *
      FROM
        question_follows
      JOIN
        users
      ON
        users.id = question_follows.user_id
      WHERE
        question_id = ?
    SQL
    return nil unless data.length>0
    data.map{|user| User.new(user)}
  end

  def self.followed_questions_for_user_id(user_id)
    #returns an array of Question objects
    data = QuestionDBConnection.instance.execute(<<-SQL,user_id)
      SELECT
        *
      FROM
        question_follows
      JOIN
        questions
      ON
        questions.id = question_follows.question_id
      WHERE
        user_id = ?
    SQL
    return nil unless data.length>0
    data.map{|question| Question.new(question)}
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def self.most_followed_questions(n)
    data = QuestionDBConnection.instance.execute(<<-SQL,n)
      SELECT
        question_id, title, body, author_id, COUNT(*) as num_followers
      FROM
        question_follows
      JOIN
        questions
      ON
        questions.id = question_follows.question_id
      group by question_id
      ORDER BY num_followers DESC
      LIMIT ?
    SQL
    return nil unless data.length>0
    data.map{|question| Question.new(question)}
  end


end
