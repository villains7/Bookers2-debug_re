class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites,dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  is_impressionable counter_cache: true
  validates :rate, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1}, presence: true

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?',content + '%')
    elsif method == 'backward'
      Book.where('title LIKE ?','%' + content)
    else
      Book.where('title LIKE ?','%' + content + '%')
    end
  end

  def create_notification_like(current_user)
   temp = Notification.new(["visitor_id = ? and visited_id = ? and book_id = ? and action = ? ", current_user.id, user_id, id,'favorite'])
   if temp.blank?
      notification = current_user.active_notifications.new(
        book_id: id,
        visited_id: user_id,
        action: 'favorite'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
   end
  end

  def create_notification_comment!(current_user,book_comment_id)
    #自分以外にコメントしている人を全部取得し、全員に通知を送る
    temp_ids = BookComment.select(:user_id).where(book_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user,book_comment_id,temp_id['user_id'])
    end
    #まだ誰もコメントをしていない場合は投稿者に通知を送る
    save_nortification_comment!(current_user,book_comment_id,user_id) if temp_ids.blank?
  end
  def save_notification_comment!(current_user,book_comment_id,visited_id)
    #コメントは複数回することが考えられるため1つの投稿に対して複数回通知する
    notification = current_user.active_notifications.new(book_id: id, book_comment_id: visited_id,action: 'comment')
    #自分の投稿に対するコメントの場合は通知済みにする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
     notification.save if notification.valid?
  end
end
