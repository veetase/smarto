贔玄閣API使用说明
===============
###历史修改
姓名 | 版本 | 备注 | 时间
-----|------|------|--------
王广星 | 0.1 | 第一版，供内测 | 2015-03-24

###描述
- 为iOS客户端提供接口
- 规范接口通讯格式
- 参考手册

#接口介绍
##请求
###请求格式
http header中需带有以下参数:

描述  |  key  |  value  |  可空
------|-------|---------|----------
身份验证 | Authorization | auth_token | true
接口版本 | Accept        | application/vnd.smarto.v1 | true
格式    | Content-type  | application/json  | false

备注：auth_token在第一次登录后由服务器返回； 接口版本由application/vnd.smarto.v1 最后一位数字指定，如果为空则遵从服务器默认提供的版本，现阶段默认版本是1。

###请求地址
>http://api.bixuange.com/xxxxx


##返回
###返回结果处理
返回结果由http状态码和内容构成，其中http状态码代表处理结果，内容是根据处理结果不同而不同，如果成功则返回正常的结果，如果失败则会将失败信息包含在errors中。

###返回格式
>json

# 详细接口介绍
## 注册
### 请求
http请求方式（以下简称方式）：POST

地址：http://api.bixuange.com/users.json (以下省略http://api.bixuange.com 部分)

示例：

```javascript
{
	"user": {
		"phone": "734569969@qq.com",
		"password" : "1234"
	}
}
```
参数含义：email: 默认的账户类型（之后会添加微信等其它登录方式），password：密码。


### 返回：

##### 成功
状态码：201

示例：

```javascript
{
    "auth_token": "MoNcGKZdL7rysXjxdVcX",
    "auth_token_expire_at": "2015-04-15T08:18:16.284Z",
    "avatar": "",
    "created_at": "2015-03-16T08:18:16.283Z",
    "phone": "18888888888",
    "updated_at": "2015-03-16T08:18:16.283Z"
}
```

返回内容含义：

* phone: 手机号
* auth_token: 用于验证用户信息
* created_at: 用户创建时间
* avatar: 用户头像地址（用户未上传头像之前的默认头像）

##### 失败
状态码：500， 422 等非 201
示例：

```javascript
{
    "errors": {
        "email": "is already taken",
        "password": [
            "is too short",
            "is invalid format"
        ],
    }
}
```

返回内容含义：

* phone, password: 导致失败的字段
* phone键对应的值: 失败的原因


## 登录
### 请求
方式：POST

地址：/sessions.json

示例：

```javascript
{
	"session": {
		"phone": "18902436654",
		"password" : "1234"
	}
}
```
参数含义：phone: 默认的账户类型（之后会添加微信等其它登录方式），password：密码。


### 返回：

##### 成功
状态码：200

示例：

```javascript
{
    "auth_token": "xZBqs3maEws1B3idiwHb",
    "avatar": ""
}
```

返回内容含义：

* auth_token: 用于验证用户信息
* avatar: 用户头像地址（用户未上传头像之前的默认头像）

##### 失败
状态码：500， 422 等非 201


## 登出（退出登录）
### 请求
方式：DELETE

地址：/sessions/logout.json

身份验证: 是


### 返回：

##### 成功
状态码：204

##### 失败
状态码：非204


## 发送温度信息
### 请求
方式：POST

地址：/spots.json

身份验证: 否（未登录状态下，user——id为空）

示例：

```javascript
{
  "spot":{
    "perception_value": 40,
    "perception_tags": ["nihao", "bucuo"],
    "comment": "hahahahaha",
    "avg_temperature": 15,
    "mid_temperature": 15.5,
    "min_temperature": 10.2,
    "max_temperature": 20.8,
    "start_measure_time": "2015-03-26 16:28:47 +0800",
    "measure_duration": 60,
    "image": "http://pan.baidu.com/test.jpg",
    "image_shaped": "http://pan.baidu.com/test.jpg",
    "is_public": true,
    "location": "POINT(50.55 50.55)",
    "category": 1
  }
}
```
参数含义：

- location: 位置信息。 type: 位置类型（包括点，线，形状）这里表示用户所在点； coordinates：坐标，经度在前，纬度在后。
- perception_value: 主管感受值。
- perception_tags：用户选定的表达自己想法的标签。
- comment: 用户自己编辑的评论，想法。
- image：图片地址。
- image_shaped: 处理后的图片地址（切图？ 压缩？）
- temperature: 温度信息, 分别代表最高温度，最低温度，温度中值，和平均温度，单位：摄氏度。
- start_measure_time: 开始测量的时间点。
- measure_duration: 测量时长，单位：秒。
- type: 类型，int值。indoor：0，outdoor：1，body：2


### 返回：

##### 成功
状态码：201

示例：

```javascript
{
    "result": "success"
}
```

返回内容含义：

* result: 处理结果。用http状态码也可判断

##### 失败
状态码：非201

返回内容含义：

* errors 键对应的值: 失败的原因


## 获取当前位置温度信息
### 请求
方式：GET

地址：/spots/around/:area_id/:longitude/:latitude/:distance.json

身份验证: 否

示例：

```javascript
	http://api.bixuange.com/spots/around/101010100/50.55/50.55/1000.json
```
参数含义：

- distance: 表示距离用户当前点的距离，单位为米。
- area_id: 用户所在位置在weather_cn中对应的area_id，area_id与城市对应表请参考weather cn的《常规数据接口区域ID(areaid)》表。
- longitude: 经度。
- latitude: 纬度。


### 返回：

##### 成功
状态码：200

示例：

```javascript

  	{
    "spots": [
        {
            "id": 1,
            "perception_value": 40,
            "perception_tags": [
                "nihao",
                "bucuo"
            ],
            "comment": "hahahahaha",
            "avg_temperature": 15,
            "mid_temperature": 15,
            "max_temperature": 15,
            "min_temperature": 15,
            "start_measure_time": "2015-03-26T08:28:47.000Z",
            "measure_duration": 60,
            "image": "http://pan.baidu.com/test.jpg",
            "image_shaped": "http://pan.baidu.com/test.jpg",
            "location": "POINT (50.55 50.55)",
            "user": {
                "nick_name": "",
                "avatar": "",
                "gender": null
            }
        }
    ],
		"station_spots": [
			{...}
		]
}
```

返回内容含义：

* spots: 周围其它用户发表的温度信息。geo_near_distance表示距离用户当前位置的距离。其它字段含义参考上传温度信息。
* station_spots: 地铁站温度信息


##### 失败
状态码：非200

##  忘记密码
### 请求
方式：POST

地址：/passwords.json

身份验证: 否

示例：

```javascript
{
  "user":{
    "phone": "734569969@qq.com"
  }
}
```
参数含义：

- phone: 用户手机号，重置密码时用来接收系统发送的验证码。


### 返回：

##### 成功
状态码：201

##### 失败
状态码：非201

##重置密码
### 请求
方式：POST

地址：//passwords/reset.json

身份验证: 否

示例：

```javascript
{
  "user":{
    "phone": "734569969@qq.com",
    "password": "88888888",
    "reset_password_token": "QLTWYX"
  }
}
```
参数含义：

- phone: 用户手机号。
- password: 新密码
- reset_password_token: 校验码，在忘了密码流程里发往用户邮箱，在重置密码用于验证。


### 返回：

##### 成功
状态码：201

##### 失败
状态码：非201


## 修改用户信息
### 请求
方式：PUT

地址：/users/\(user_id)}.json

身份验证: 否

示例：

请求链接：http://api.bixuange.com/users/2.json

参数：

```javascript

	{
  		"user":{
    		"phone": "734569969@qq.sbb.com",
    		"nick_name": "ssssssbddddbbbb",
    		"gender": 1,
      		"figure": 2,
      		"tags": ["nice", "healthy"]

  		}
	}
```

### 返回：

##### 成功
状态码：200
内容为更新后的用户信息

##### 失败
状态码：非200

## 获取七牛upload token
### 请求
方式：GET

地址：/qiniu_token/\(bucket_name)}.json

身份验证: 否

示例：

请求链接：http://api.bixuange.com/qiniu_token/avatar.json

参数：bucket_name

### 返回：

##### 成功
状态码：200

{
    "qiniu_token": qiniu_upload_token,
    "expire_at": unix time(upload token的过期时间，默认为20个小时)
}

##### 失败
状态码：非200

## 检查手机号码是否被注册
### 请求
方式：GET

地址：/user/check_phone/\(phone).json

身份验证: 否

### 返回：

##### 成功
状态码：200

{
    "registed": true,
    "sign": xxxxx(如果未被注册则sign为云之讯的签名，如果注册则为空)
}

##### 失败
状态码：非200

## 获取用户的兑换券
### 请求
方式：GET

地址：/vouchers.json

身份验证: 是

### 返回：
##### 成功
状态码：200

## 激活兑换券
### 请求
方式：POST

地址：/vouchers/\(voucher_code).json

身份验证: 是

### 返回：
##### 成功
状态码：204
## 提交赞, 取消赞
### 请求
方式：POST

地址：/spots/\(spot_id)/like.json ; /spots/\(spot_id)/unlike.json
身份验证: 否

### 返回：
##### 成功
状态码：204

## 获取spot评论
### 请求
方式：GET

地址：/spots/\(spot_id)/spot_comments/page/\(page_id).json

例如：http://api.bixuange.com/spots/30/spot_comments/page/1.json
身份验证: 否

## 提交spot评论
### 请求
方式：POST

地址：/spots/\(spot_id)/spot_comments.json

body:
{
  "spot_comment": {"content": "要提交的评论"}
}
身份验证: 否
