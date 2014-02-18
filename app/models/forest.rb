class Forest < ActiveRecord::Base
  before_save :do_stuff
  has_many :trees
  accepts_nested_attributes_for :trees, allow_destroy: true
  attr_accessible :trees_attributes

  attr_accessible :climate, :latitude, :longitude, :name, :size, :special_scenario
  
  attr_accessor :special_scenario

  validates_presence_of :name
  validates_presence_of :size
  validates_presence_of :climate
  validates_presence_of :latitude
  validates_presence_of :longitude

  def do_stuff
    puts special_scenario.inspect
  end
end
