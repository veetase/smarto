class BxgQiniu
  def self.create_token(bucket)
    raise Api::NotFound unless ["avatar"].include? bucket
    expire_at = Time.now.in(72000).to_i
    put_policy = Qiniu::Auth::PutPolicy.new(
      scope: bucket,     # 存储空间
      #72000 相对有效期，可省略，缺省为3600秒后 uptoken 过期
      deadline: expire_at    # 绝对有效期，可省略，指明 uptoken 过期期限（绝对值），通常用于调试
    )

    uptoken = Qiniu::Auth.generate_uptoken(put_policy)
    return {qiniu_token: uptoken, expire_at: expire_at}
  end
end
