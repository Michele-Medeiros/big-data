class User < ApplicationRecord
  searchable do
    text :first_name
    text :last_name
    text :email
    text :address
    text :city
    integer :zip_code
    text :company
    text :company_description
  end
end
