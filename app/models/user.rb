class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :comments
  has_many :posts
  has_many :likes
  has_many :liked_posts, through: :likes, source: :post
  # 아래 주석과 같이 하면 헷갈릴 수 있으므로 liked_posts로 표현한다. 그러나 이는 약속을 깬 것이므로, 뒤에 through와 source를 표현해준다.
  # has_many :posts, through :likes # M : N 관계위해
end
