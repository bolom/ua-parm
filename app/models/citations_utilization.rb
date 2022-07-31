class CitationsUtilization < ApplicationRecord
  belongs_to :citation, optional: true
  belongs_to :utilization, optional: true
end
