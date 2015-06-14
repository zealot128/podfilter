class CsvFormatter
  def self.hash_to_excel_csv(collection, encode: true)
    require "csv"
    keys = Set.new([])
    collection.each do |item|
      keys += item.keys
    end
    keys.sort

    resp = CSV.generate(:col_sep => ";", :force_quotes => true) do |csv|
      csv << keys.map{|i|i.to_s.titleize}
      collection.each do |job|
        values = keys.map do |key|
          val = job[key]
          if val.is_a?(Array)
            val = val.join('|')
          end
          val
        end
        csv << values
      end
    end

    resp.encode(Encoding::ISO_8859_1, :undef => :replace)
  end

  def self.call(object, env)
    hash_to_excel_csv(object)
  end
end
