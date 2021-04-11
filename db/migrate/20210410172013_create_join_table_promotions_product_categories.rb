class CreateJoinTablePromotionsProductCategories < ActiveRecord::Migration[6.1]
  def change
    create_join_table :promotions, :product_categories do |t|
      # t.index [:promotion_id, :product_category_id]
      # t.index [:product_category_id, :promotion_id]
    end
  end
end
