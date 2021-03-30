class Promotion < ApplicationRecord
    belongs_to :user
    has_many :coupons, dependent: :delete_all
    has_one :promotion_approval

    validates :name, :code, :discount_rate, :coupon_quantity, 
              :expiration_date, presence: true
    validates :name, :code, uniqueness: true

    def generate_coupons!
        return if coupons?

        Coupon.transaction do
            (1..coupon_quantity).each do |number|
                coupons.create!(code: "#{code}-#{'%04d' % number}")
            end
        end
    end

    def coupons?
        coupons.any?
    end

    def self.search(query)
        where('name LIKE ?', "%#{query}%").limit(5)
    end

    def approved?
        promotion_approval.present?
    end
end
