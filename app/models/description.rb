class Description < ApplicationRecord
  belongs_to :descriptionable, :polymorphic => true
end
