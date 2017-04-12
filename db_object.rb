require_relative 'questions_db'

class DBObject
  def self.find_by_id(id)
    table = MAPPINGS[self.class]
    result = QuestionsDBConnection.instance.execute(<<-SQL,id)
    SELECT
      *
    FROM
      #{table}
    WHERE
      id = ?
    SQL
    return nil unless result.length > 0
    self.class.new(result.first)
  end

  MAPPINGS = {
    User: 'users'
  }

end
