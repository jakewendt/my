require 'mysql'

#my = Mysql.new(hostname, username, password, databasename)
con = Mysql.new('localhost', '', '', 'student')
rs = con.query('select * from student')
rs.each_hash { |h| puts h['name']}
con.close
