class Distribution < ApplicationRecord
  belongs_to :distributionable, :polymorphic => true
end
