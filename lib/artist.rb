class Artist
  attr_accessor :name, :id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id) # Note that this line has been changed.
  end

  def self.all
  returned_artists = DB.exec("SELECT * FROM artists ORDER BY name;")
  artists = []
  returned_artists.each() do |artist|
    name = artist.fetch("name")
    id = artist.fetch("id").to_i
    artists.push(Artist.new({:name => name, :id => id}))
  end
  artists
  end

  def save
    result = DB.exec("INSERT INTO artists (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(artist_to_compare)
    self.name() ==artist_to_compare.name()
  end

  def self.clear
  DB.exec("DELETE FROM artists *;")
  end

  def self.find(id)
    artist = DB.exec("SELECT * FROM artists WHERE id = #{id};").first
    name = artist.fetch("name")
    id = artist.fetch("id").to_i
    Artist.new({:name => name, :id => id})
  end

end
