# frozen_string_literal: true

class Base < ApplicationRecord
  validates :office_number, presence: true, uniqueness: true
  validates :office_name, presence: true
  validates :office_category, presence: true
end
