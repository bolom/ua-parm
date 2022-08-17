class NamePlant < ApplicationRecord
  belongs_to :name
  belongs_to :plant

  def self.all_names
    self.includes(:name).order(label: :asc).pluck('names.label', :plant_id)
  end
end
