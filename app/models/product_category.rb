class ProductCategory < ApplicationRecord
    has_and_belongs_to_many :promotions
    validates :name, :code, presence: true
    validates :name, :code, uniqueness: true
    SEARCHABLE_FIELDS = %w[name code].freeze

    def self.search(query)
        where(
            SEARCHABLE_FIELDS
                .map { |field| "#{field} LIKE :query" }
                .join(' OR '), 
             query: "%#{query}%")
        .limit(5)
    end
end
