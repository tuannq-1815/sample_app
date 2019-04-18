class Micropost < ApplicationRecord
  belongs_to :user
  scope :order_by_create, -> {order created_at: :desc}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length:{ maximum: Settings.microposts_max}
  validate  :picture_size
  private

  def picture_size
    if picture.size > Settings.picture_size.megabytes
      errors.add :picture, t(".should_be")
    end
  end
end
