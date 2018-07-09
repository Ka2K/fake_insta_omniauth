class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :user
  has_many :likes
  has_many :liked_users, through: :likes, source: :post
  # 아래 주석과 같이 하면 헷갈릴 수 있으므로 liked_users로 표현한다. 그러나 이는 약속을 깬 것이므로, 뒤에 through와 source를 표현해준다.
  # has_many :users, through: :likes # M : N 관계
  mount_uploader :img, ImgUploader
  # 검증 (model validation)
  validates :title, presence: {message: "제목을 입력해 주세요."} , length: {maximum: 30, too_long: "%{count}자 이내로 입력해 주세요."}
  validates :content, presence: {message: "내용을 입력해 주세요."}
end
