class UtilizationCitation < ApplicationRecord
  belongs_to :citation
  belongs_to :utilization
end
