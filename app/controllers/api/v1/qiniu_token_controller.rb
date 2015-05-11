require 'uti/qiniu'
class Api::V1::QiniuTokenController < ApplicationController
  def create
    bucket = params[:bucket]
    token = BxgQiniu.create_token(bucket)
    render json: token
  end
end
