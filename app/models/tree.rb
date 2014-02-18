class Tree < ActiveRecord::Base
  before_validation :raise_error_if_special_scenario, unless: :new_record?
  belongs_to :forest
  attr_accessible :common_name, :forest_id, :scientific_name
  
  validates_presence_of :common_name
  validates_presence_of :scientific_name

  private

    def raise_error_if_special_scenario
      raise 'puke' if forest.special_scenario
    end
end
