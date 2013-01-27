class Tree < ActiveRecord::Base
  belongs_to :forest
  attr_accessible :common_name, :forest_id, :scientific_name
  
  validates_presence_of :common_name
  validates_presence_of :scientific_name
end
