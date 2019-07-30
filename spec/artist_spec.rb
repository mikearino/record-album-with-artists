require 'spec_helper'

describe '#Artist' do

  # before(:each) do
  #   @artist = Artist.new({:name => "Giant Steps", :id => nil})
  #   @artist.save()
  # end

  describe('.all') do
    it("returns an empty array when there are no artists") do
      expect(Artist.all).to(eq([]))
    end
  end

  describe('#save') do
    it("saves an artist") do
      artist = Artist.new({:name => "A Love Supreme", :id => nil})
      artist.save()
      artist2 = Artist.new({:name => "Blue", :id => nil})
      artist2.save()
      expect(Artist.all).to(eq([artist, artist2]))
    end
  end

  describe('.clear') do
    it("clears all artists") do
      artist = Artist.new({:name => "Salyer", :id => nil})
      artist.save()
      artist2 = Artist.new({:name => "Blue", :id => nil})
      artist2.save()
      Artist.clear
      expect(Artist.all).to(eq([]))
    end
  end

  describe('.find') do
    it("finds an artist by id") do
      artist = Artist.new({:name => "A Love Supreme", :id => nil})
      artist.save()
      artist2 = Artist.new({:name => "Blue", :id => nil})
      artist2.save()
      expect(Artist.find(artist.id)).to(eq(artist))
    end
  end

  describe('#delete') do
    it("deletes an artist by id") do
      artist = Artist.new({:name => "A Love Supreme", :id => nil})
      artist.save()
      artist2 = Artist.new({:name => "Blue", :id => nil})
      artist2.save()
      artist.delete()
      expect(Artist.all).to(eq([artist2]))
    end
  end

  describe('#update_name') do
    it("updates an artist by id") do
      artist = Artist.new({:name => "A Love Supreme", :id => nil})
      artist.save()
      artist.update_name("A Love Supreme")
      expect(artist.name).to(eq("A Love Supreme"))
    end
  end

  describe('#update') do
  it("adds an album to an artist") do
    artist = Artist.new({:name => "John Coltrane", :id => nil})
    artist.save()
    album = Album.new({:name => "A Love Supreme", :id => nil, :release_year => 2020})
    album.save()
    artist.update({:album_name => "A Love Supreme"})
    expect(artist.albums).to(eq([album]))
  end
end


end
