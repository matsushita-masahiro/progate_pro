class AddVideoNameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :video_name, :string
  end
end
