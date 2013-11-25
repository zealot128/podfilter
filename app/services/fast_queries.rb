module FastQueries
  module_function
  def episode_count
    Episode.connection.execute('SELECT reltuples FROM pg_class WHERE relname = \'episodes\'').first.values.first
  end
end
