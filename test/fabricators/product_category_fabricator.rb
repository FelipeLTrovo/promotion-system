Fabricator(:product_category)do
    name { sequence(:name) {|i| "Produto Antifraude#{i}"}}
    code { sequence(:code) {|i| "ANTIFRA#{i}"}}
end