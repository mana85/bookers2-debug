class CreateGroupUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :group_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :group, undex: true, foreign_key: true

      t.timestamps
    end
  end
end
