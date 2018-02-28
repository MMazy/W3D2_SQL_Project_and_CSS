require_relative 'questions.rb'

class QuestionLike
  attr_accessor :question_id, :user_id

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM question_likes")
    data.map{|q| QuestionLike.new(q)}
  end

  def self.find_by_id(id)
    question_like = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL
    return nil unless question_like.length>0
    QuestionLike.new(question_like)
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def self.likers_for_question_id(question_id)
    data = QuestionDBConnection.instance.execute(<<-SQL,question_id)
      SELECT
        *
      FROM
        question_likes
      JOIN
        users
      ON
        users.id = question_likes.user_id
      WHERE
        question_id = ?
    SQL
    return nil unless data.length>0
    data.map{|user| User.new(user)}
  end

end
