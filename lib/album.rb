class Album
  attr_accessor :name, :release_year
  attr_reader :id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id) # Note that this line has been changed.
    @release_year = attributes.fetch(:release_year)
  end

  def self.all
  returned_albums = DB.exec("SELECT * FROM albums ORDER BY name;")
  albums = []
  returned_albums.each() do |album|
    name = album.fetch("name")
    id = album.fetch("id").to_i
    release_year = album.fetch("release_year").to_i
    albums.push(Album.new({:name => name, :id => id, :release_year => release_year}))
  end
  albums
  end

  def save
    result = DB.exec("INSERT INTO albums (name, release_year) VALUES ('#{@name}', #{@release_year}) RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(album_to_compare)
    self.name() == album_to_compare.name()
  end

  def self.clear
  DB.exec("DELETE FROM albums *;")
  end

  def self.find(id)
    album = DB.exec("SELECT * FROM albums WHERE id = #{id};").first
    name = album.fetch("name")
    id = album.fetch("id").to_i
    release_year = album.fetch("release_year").to_i
    Album.new({:name => name, :id => id, :release_year => release_year})
  end

  def update(name)
    @name = name
    DB.exec("UPDATE albums SET name = '#{@name}' WHERE id = #{@id};")
  end

  def update_artist(attributes)
    if (attributes.has_key?(:name)) && (attributes.fetch(:name) != nil)
      @name = attributes.fetch(:name)
      DB.exec("UPDATE albums SET name = '#{@name}' WHERE id = #{@id};")
    end
    artist_name = attributes.fetch(:artist_name)
    if artist_name != nil
      artist = DB.exec("SELECT * FROM artists WHERE lower(name)='#{artist_name.downcase}';").first
      if artist != nil
        DB.exec("INSERT INTO albums_artists (album_id, artist_id) VALUES (#{@id}, #{artist['id'].to_i});")
      end
    end
  end

  def delete
    DB.exec("DELETE FROM albums WHERE id = #{@id};")
    DB.exec("DELETE FROM songs WHERE album_id = #{@id};") # new code
  end

  def songs
    Song.find_by_album(self.id)
  end

  def alphabetical
    DB.exec("SELECT * FROM songs ORDER BY name")
  end

  def artists
    artists = []
    results = DB.exec("SELECT artist_id FROM albums_artists WHERE album_id = #{@id};")
    binding.pry
    results.each do |result|
      binding.pry
      artist_id = result.fetch("artist_id").to_i()
      artist = DB.exec("SELECT * FROM artists WHERE id = #{artist_id};")
      name = artist.first().fetch("name")
      artists.push(Artist.new({:name => name, :id => artist_id}))
    end
    artists
  end

end
