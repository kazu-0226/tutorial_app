class User
    attr_accessor :name, :email #インスタンス変数を読み書きするアクセサメソッドを生成。 
  
    def initialize(attributes = {}) #Userクラス生成時に自動実行されるメソッドを定義
      @name  = attributes[:name] #nameキーが存在しない場合、ハッシュはnilを返す
      @email = attributes[:email] #emailキーが存在しない場合、ハッシュはnilを返す
    end
  
    def formatted_email #インスタンス変数に割り当てられた値をユーザーのメールアドレスとして構成する
      "#{@name} <#{@email}>"  #@nameと@emailに割り当てられた値を表示
    end
  end