require 'sqlite3'
require 'singleton'
require_relative 'question_follows.rb'
require_relative 'question_like.rb'
require_relative 'question.rb'
require_relative 'reply.rb'
require_relative 'user.rb'

class QuestionDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end
