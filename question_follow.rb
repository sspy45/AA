require_relative "questions_db"

class QuestionFollow
  attr_accessor :id, :question_id, :user_id

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def self.find_by_id(id)
    follow = QuestionsDBConnection.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      question_follows
    WHERE
      id = ?
    SQL
    return nil unless follow.length > 0
    QuestionFollow.new(follow.first)
  end

  def self.followers_for_question_id(question_id)
    followers = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        users.id
      FROM
        users
      JOIN
        question_follows ON users.id = question_follows.user_id
      WHERE
        question_follows.question_id = ?

    SQL
    return nil unless followers.length > 0
    followers.map { |hash| User.find_by_id(hash['id'])}
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id
      FROM
        questions
      JOIN
        question_follows ON question_follows.question_id = questions.id
      WHERE
        question_follows.user_id = ?

    SQL
    return nil unless questions.length > 0

    questions.map { |hash| Question.find_by_id(hash["id"])}
  end

  def self.most_followed_questions(n)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, n)
      SELECT
        question_id, COUNT(user_id)
      FROM
        question_follows
      GROUP BY
        question_id
      ORDER BY
        COUNT(user_id) DESC
      LIMIT
        ?
    SQL

    return nil unless questions.length > 0
    result = questions.map { |hash| Question.find_by_id(hash["question_id"])}
    result
  end

end
