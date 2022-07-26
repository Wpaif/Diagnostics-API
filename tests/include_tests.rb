Dir["#{Dir.pwd}/*.rb"].to_a.each { |file| file == [Dir.pwd, $0].join('/') ? next : (require file) }
