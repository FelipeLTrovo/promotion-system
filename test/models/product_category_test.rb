require "test_helper"

class ProductCategoryTest < ActiveSupport::TestCase
  test 'attributes cannot be blank' do
    product_category = ProductCategory.new

    refute product_category.valid?
    assert_includes product_category.errors[:name], 'não pode ficar em branco'
    assert_includes product_category.errors[:code], 'não pode ficar em branco'
  end

  test 'code must be uniq' do
    ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')
    product_category = ProductCategory.new(code: 'ANTIFRA')

    refute product_category.valid?
    assert_includes product_category.errors[:code], 'já está em uso'
  end

  test 'name must be uniq' do
    ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')
    product_category = ProductCategory.new(name: 'Produto AntiFraude')

    refute product_category.valid?
    assert_includes product_category.errors[:name], 'já está em uso'
  end
end
