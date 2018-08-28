class AddFollowedIdFriends < ActiveRecord::Migration[5.2]
  def change
    add_column :friends, :followed_id, :integer
  end
end
