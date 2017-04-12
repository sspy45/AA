require_relative "questions_db"


class QuestionLike
  attr_accessor :id, :user_id, :question_id

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def self.find_by_id(id)
    like = QuestionsDBConnection.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      questions_like
    WHERE
      id = ?
    SQL
    return nil unless like.length > 0
    QuestionLike.new(like.first)
  end

  def self.likers_for_question_id(question_id)
    users = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
    SELECT
      user_id
    FROM
      questions_like
    WHERE
      question_id = ?
    SQL
    return nil unless users.length > 0
    results = users.map { |hash| User.find_by_id(hash["user_id"])}
    results
  end

  def self.num_likes_for_question_id(question_id)
    likes = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
    SELECT
      COUNT(user_id) AS Likes
    FROM
      questions_like
    WHERE
      question_id = ?
    SQL
    return nil unless likes.length > 0
    results = likes.map { |hash| hash["Likes"] }
    results
  end

  def self.liked_questions_for_user_id(user_id)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
    SELECT
      question_id
    FROM
      questions_like
    WHERE
      user_id = ?
    SQL
    return nil unless questions.length > 0
    results = questions.map { |hash| Question.find_by_id(hash["question_id"]) }
    results
  end

  def self.most_liked_questions(n)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, n)
      SELECT
        question_id, COUNT(user_id)
      FROM
        quetions_like
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
