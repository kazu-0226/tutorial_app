class User < ApplicationRecord
    has_many :microposts, dependent: :destroy

    has_many :active_relationships, class_name:  "Relationship",foreign_key: :follower_id, dependent: :destroy
    has_many :passive_relationships,class_name: "Relationship",foreign_key: :followed_id, dependent: :destroy
    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower

    attr_accessor :remember_token, :activation_token     , :reset_token                         # 記憶トークンと有効化トークンを定義
    before_save { email.downcase! }                                               #DB保存前にemailの値を小文字に変換する
    before_create :create_activation_digest                                       # 作成前に適用
    validates :name,  presence: true, length: { maximum:  50 }                    #nameの文字列が空でなく、50文字以下ならtrue
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i                      #正規表現でemailのフォーマットを策定し、定数に代入
    validates :email, presence: true, length: { maximum: 255 },                   #emailの文字列が空でなく、255文字以下ならtrue
                      format: { with: VALID_EMAIL_REGEX },                        #emailのフォーマットを引数に取ってフォーマット通りか検証する。
                      uniqueness: { case_sensitive: false }                       #大文字小文字を区別しない(false)に設定する このオプションでは通常のuniquenessはtrueと判断する
    
    has_secure_password                         #passwordとpassword_confirmation属性に存在性と値が一致するかどうかの検証が追加される
    validates :password, presence: true,
      length: { minimum: 6 }, allow_nil: true   #passwordの文字列が空でなく、6文字以上ならtrue。例外処理に空(nil)の場合のみバリデーションを通す(true)
  
    def User.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  
    def User.new_token
      SecureRandom.urlsafe_base64
    end
  
    def remember
      self.remember_token = User.new_token
      self.update_attribute(:remember_digest,
        User.digest(remember_token))
    end
  
    def forget
      self.update_attribute(:remember_digest, nil)
    end
  
    # 渡されたトークンがダイジェストと一致したらtrueを返す
    def authenticated?(attribute, token)
      digest = send("#{attribute}_digest")
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end

      # アカウントを有効にする
      def activate
        update_attribute(:activated, true)
        update_attribute(:activated_at, Time.zone.now)
      end

    # 有効化用のメールを送信する
    def send_activation_email
      UserMailer.account_activation(self).deliver_now
    end

        # パスワード再設定の属性を設定する
    def create_reset_digest
      self.reset_token = User.new_token
      update_attribute(:reset_digest,  User.digest(reset_token))
      update_attribute(:reset_sent_at, Time.zone.now)
    end

    # パスワード再設定のメールを送信する
    def send_password_reset_email
      UserMailer.password_reset(self).deliver_now
    end

    # パスワード再設定の期限が切れている場合はtrueを返す
    def password_reset_expired?
      reset_sent_at < 2.hours.ago
    end

    # 試作feedの定義
  # 完全な実装は次章の「ユーザーをフォローする」を参照
  def feed
    Micropost.where("user_id = ?", id)
  end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end
  # ユーザーをフォロー解除する
  def unfollow
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end


  private

  # メールアドレスをすべて小文字にする
  def downcase_email
    self.email = email.downcase
  end

  # 有効化トークンとダイジェストを作成および代入する
  def create_activation_digest
    self.activation_token  = User.new_token                 # ハッシュ化した記憶トークンを有効化トークン属性に代入
    self.activation_digest = User.digest(activation_token)  # 有効化トークンをBcryptで暗号化し、有効化ダイジェスト属性に代入
  end


end