if Owner.count == 0
  owner = Owner.create
  Dir['db/seeds/*'].each do |file|
    import = OpmlImport.new File.open(file), owner
    import.run!
    puts import.log.join("\n")
  end
end
