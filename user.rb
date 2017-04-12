require_relative "questions_db"

class User < DBObject
  attr_accessor :id, :fname, :lname

  def initialize(options)
    @id = options[:id]
    @fname = options[:fname]
    @lname = options[:lname]
  end

  def save
    if @id
      update
    else
      QuestionsDBConnection.instance.execute(<<-SQL, @fname, @lname)
      INSERT INTO
        users (fname, lname)
      VALUES
        (?, ?)
      SQL
      @id = QuestionsDBConnection.instance.last_insert_row_id
    end
  end

  def update
    QuestionsDBConnection.instance.execute(<<-SQL, @id, @fname, @lname)
    UPDATE
      users
    SET
      fname = ? , lname = ?
    WHERE
      id = ?
    SQL
  end

  # def self.find_by_id(id)
  #   user = QuestionsDBConnection.instance.execute(<<-SQL, id)
  #   SELECT
  #     *
  #   FROM
  #     users
  #   WHERE
  #     id = ?
  #   SQL
  #   return nil unless user.length > 0
  #   User.new(user.first)
  # end

  def self.find_by_name(fname, lname)
    user = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
    SELECT
      *
    FROM
      users
    WHERE
      fname = ? AND lname = ?
    SQL
    return nil unless user.length > 0
    User.new(user.first)
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    # debugger
    questions = Question.find_by_author_id(@id)

    sum = 0
    questions.each do |question|
      sum += question.num_likes.first
    end
    sum / questions.count
  end

end
