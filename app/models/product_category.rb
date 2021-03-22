class ProductCategory < ApplicationRecord
    validates :name, :code, presence: true
    validates :name, :code, uniqueness: true
end
