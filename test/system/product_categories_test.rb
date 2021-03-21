require 'application_system_test_case'

class ProductCategoriesTest < ApplicationSystemTestCase
    test 'view product categories' do
        ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')
        ProductCategory.create!(name: 'Produto Premium', code: 'PREMIUM')

        visit root_path
        click_on 'Categorias de Produtos'

        assert_text 'Produto AntiFraude'
        assert_text 'Produto Premium'
    end

    test 'view product category details' do
        ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')
        ProductCategory.create!(name: 'Produto Premium', code: 'PREMIUM')

        visit product_categories_path
        click_on 'Produto AntiFraude'

        assert_text 'Produto AntiFraude'
        assert_text 'ANTIFRA'
        assert_no_text 'Produto Premium'
    end

    test 'no product categories are available' do
        visit root_path
        click_on 'Categorias de Produtos'
    
        assert_text 'Nenhuma categoria de produto cadastrada'
    end

    test 'view product categories and return to home page' do
        ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')
        visit root_path
        click_on 'Categorias de Produtos'
        click_on 'Voltar'

        assert_current_path root_path
    end

    test 'view details and return to all product categories page' do
        ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')
        visit root_path
        click_on 'Categorias de Produtos'
        click_on 'Produto AntiFraude'
        click_on 'Voltar'

        assert_current_path product_categories_path
    end

    test 'create product category' do
        visit root_path
        click_on 'Categorias de Produtos'
        click_on 'Registrar uma categoria de produto'
        fill_in 'Nome', with: 'Produto AntiFraude'
        fill_in 'Código', with: 'ANTIFRA'
        click_on 'Criar categoria de produto'
        assert_current_path product_category_path(ProductCategory.last)
        assert_text 'Produto AntiFraude'
        assert_text 'ANTIFRA'
    end

    test 'create product category and attributes cannot be blank' do
        visit root_path
        click_on 'Categorias de Produtos'
        click_on 'Registrar uma categoria de produto'
        click_on 'Criar categoria de produto'
        assert_text 'não pode ficar em branco', count: 2
    end

    test 'create product category and code/name must be unique' do
        ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')
        visit root_path
        click_on 'Categorias de Produtos'
        click_on 'Registrar uma categoria de produto'
        fill_in 'Nome', with: 'Produto AntiFraude'
        fill_in 'Código', with: 'ANTIFRA'
        click_on 'Criar categoria de produto'
        assert_text 'deve ser único', count: 2
    end

    test 'update product category' do
        product_category = ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')
        visit edit_product_category_path(product_category)
        fill_in 'Nome', with: 'Produto Premium'
        fill_in 'Código', with: 'PREMIUM'
        click_on 'Editar categoria de produto'
        assert_no_text 'Produto AntiFraude'
        assert_no_text 'ANTIFRA'
        assert_text 'Produto Premium'
        assert_text 'PREMIUM'
        assert_text 'Categoria de produtos editada com sucesso'
    end

    test 'update product category and attributes cannot be blank' do
        product_category = ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')
        visit edit_product_category_path(product_category)
        fill_in 'Nome', with: ''
        fill_in 'Código', with: ''
        click_on 'Editar categoria de produto'
        assert_text 'não pode ficar em branco', count: 2
    end

    test 'update product category and attributes must be unique' do
        ProductCategory.create!(name: 'Produto Premium', code: 'PREMIUM')
        edit_product_category = ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')
        visit edit_product_category_path(edit_product_category)
        fill_in 'Nome', with: 'Produto Premium'
        fill_in 'Código', with: 'PREMIUM'
        click_on 'Editar categoria de produto'
        assert_text 'deve ser único', count: 2
    end

    test 'delete product category' do
        ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')
        visit root_path
        click_on 'Categorias de Produtos'
        click_on 'Deletar categoria de produto'
        assert_text 'Nenhuma categoria de produto cadastrada'
    end
    
end