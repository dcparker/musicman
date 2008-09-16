require 'dm-core'
DataMapper.setup(:default, "mysql://amarok:grammy@localhost/amarok")

# +-------+--------------+------+-----+---------+----------------+
# | Field | Type         | Null | Key | Default | Extra          |
# +-------+--------------+------+-----+---------+----------------+
# | id    | int(11)      | NO   | PRI | NULL    | auto_increment | 
# | name  | varchar(255) | YES  | MUL | NULL    |                | 
# +-------+--------------+------+-----+---------+----------------+
class Artist
  include DataMapper::Resource
  property :id, Serial
  property :name, String
end
