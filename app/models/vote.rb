class Vote < ActiveRecord::Base
  attr_accessible :count, :id

  validate :count_cannot_be_negative

  def count_cannot_be_negative
    errors.add(:count, 'cannot be negative') unless count >= 0
  end
end
