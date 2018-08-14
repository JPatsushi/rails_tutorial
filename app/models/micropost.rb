class Micropost < ApplicationRecord
  belongs_to :user
  #before_validation :set_in_reply_to # 返信機能用
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  #validates :in_reply_to, presence: false # 返信機能用
  validate  :picture_size #validatesメソッドではなく、validateメソッドを使っている
  #validate  :reply_to_user # 返信機能用
  before_save { self.in_reply_to = reply_user.to_s }
  
  
  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
    
    def reply_user
      if user_unique_name = content.match(/(@[0-9][^\s]+)/)
        user_unique_name[0]
      end
    end
 
    
    # def reply_to_user
    #   return if self.in_reply_to == 0 # 1
    #   unless user = User.find_by(id: self.in_reply_to) # 2
    #     errors.add(:base, "User ID you specified doesn't exist.")
    #   else
    #     if user_id == self.in_reply_to # 3
    #       errors.add(:base, "You can't reply to yourself.")
    #     else
    #       unless reply_to_user_name_correct?(user) # 4
    #         errors.add(:base, "User ID doesn't match its name.")
    #       end
    #     end
    #   end
    # end
    
    # def reply_to_user_name_correct?(user)
    #   user_name = user.name.gsub(" ", "-")
    #   content[@index+2, user_name.length] == user_name
    # end
    
end
