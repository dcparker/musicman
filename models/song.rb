require 'dm-core'
DataMapper.setup(:default, "mysql://amarok:grammy@localhost/amarok")

# +----------+----------------+------+-----+---------+-------+
# | Field    | Type           | Null | Key | Default | Extra |
# +----------+----------------+------+-----+---------+-------+
# | url      | varbinary(255) | YES  | MUL | NULL    |       | 
# | deviceid | int(11)        | YES  |     | NULL    |       | 
# | uniqueid | varbinary(32)  | YES  | UNI | NULL    |       | 
# | dir      | varbinary(255) | YES  |     | NULL    |       | 
# +----------+----------------+------+-----+---------+-------+
class Song
  include DataMapper::Resource
  storage_names[:default] = 'uniqueid'
  property :url, String, :unique => true
  property :deviceid, Integer
  property :uniqueid, String, :key => true
  property :dir, String
end
