class RemoveInReplyToFromMicroposts < ActiveRecord::Migration[5.1]
  def change
    remove_column :microposts, :in_reply_to, :integer
    add_column :microposts, :in_reply_to, :string, default: ""
    add_index :microposts, :in_reply_to
  end
end
