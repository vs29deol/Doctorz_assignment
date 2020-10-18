class AddDataToUser < ActiveRecord::Migration[6.0]
  def change
    User.create(:name => "admin", :email => "user@gmail.com", is_admin: true, password: '123456')
  end
end
