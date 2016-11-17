class Offerte < ApplicationRecord
  has_many :posities
  enum status: [ :nieuw, :uitgebracht, :opdracht, :historisch ]


end
