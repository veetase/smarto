class BxgQiniu
  def self.create_token(bucket)
    raise Api::NotFound unless ["avatar"].include? bucket
    expire_at = Time.now.in(36000).to_i
    put_policy = Qiniu::Auth::PutPolicy.new(bucket, nil, nil, expire_at)

    uptoken = Qiniu::Auth.generate_uptoken(put_policy)
    return {qiniu_token: uptoken, expire_at: expire_at}
  end
end
