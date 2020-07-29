class SessionsController < ApplicationController
  def new
        
  end

  def create
      user = User.find_by(email: params[:session][:email].downcase) # paramsハッシュで受け取ったemail値を小文字化し、email属性に渡してUserモデルから同じemailの値のUserを探して、user変数に代入
      if user && user.authenticate(params[:session][:password]) # user変数がデータベースに存在し、なおかつparamsハッシュで受け取ったpassword値と、userのemail値が同じ(パスワードとメールアドレスが同じ値であれば)true
        log_in user # sessions_helperのlog_inメソッドを実行し、sessionメソッドのuser_id（ブラウザに一時cookiesとして保存）にidを送る
        redirect_to user #ログインしたuser(id)へ遷移→user_url(user)
      else
          flash.now[:danger] = 'Invalid email/password combination'
          render :new
      end
  end

  def destroy
    log_out
    redirect_to root_url
  end

end
