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
		"email": "734569969@qq.com",
		"password" : "12345678",
		"password_confirmation" : "12345678"
	}
}	
```
参数含义：email: 默认的账户类型（之后会添加微信等其它登录方式），password：密码，password_confirmation：密码确认。


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
    "email": "734569969@vib.qq.com",
    "updated_at": "2015-03-16T08:18:16.283Z"
}	
```

返回内容含义：

* email: 账号
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

* email, password: 导致失败的字段
* email键对应的值: 失败的原因


## 登录
### 请求
方式：POST

地址：/sessions.json

示例：

```javascript
{
	"session": {
		"email": "734569969@qq.com",
		"password" : "12345678"
	}
}	
```
参数含义：email: 默认的账户类型（之后会添加微信等其它登录方式），password：密码。


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

身份验证: 是

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
    "location": "POINT(50.55 50.55)"
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
    "weather_cn": {
        "index": {
            "i": [
                {
                    "i1": "cl",
                    "i2": "晨练指数",
                    "i3": "",
                    "i4": "不宜",
                    "i5": "有雾，空气质量差，请避免户外晨练，建议在室内做适当锻炼，保持身体健康。"
                },
                {
                    "i1": "co",
                    "i2": "舒适度指数",
                    "i3": "",
                    "i4": "舒适",
                    "i5": "白天不太热也不太冷，风力不大，相信您在这样的天气条件下，应会感到比较清爽和舒适。"
                },
                {
                    "i1": "ct",
                    "i2": "穿衣指数",
                    "i3": "",
                    "i4": "较舒适",
                    "i5": "建议着薄外套、开衫牛仔衫裤等服装。年老体弱者应适当添加衣物，宜着夹克衫、薄毛衣等。"
                }
            ]
        },
        "forecast": {
            "c": {
                "c1": "101010100",
                "c2": "beijing",
                "c3": "北京",
                "c4": "beijing",
                "c5": "北京",
                "c6": "beijing",
                "c7": "北京",
                "c8": "china",
                "c9": "中国",
                "c10": "1",
                "c11": "010",
                "c12": "100000",
                "c13": 116.391,
                "c14": 39.904,
                "c15": "33",
                "c16": "AZ9010",
                "c17": "+8"
            },
            "f": {
                "f1": [
                    {
                        "fa": "53",
                        "fb": "00",
                        "fc": "17",
                        "fd": "6",
                        "fe": "0",
                        "ff": "0",
                        "fg": "0",
                        "fh": "0",
                        "fi": "06:24|18:21"
                    },
                    {
                        "fa": "00",
                        "fb": "02",
                        "fc": "15",
                        "fd": "3",
                        "fe": "0",
                        "ff": "0",
                        "fg": "0",
                        "fh": "0",
                        "fi": "06:23|18:22"
                    },
                    {
                        "fa": "02",
                        "fb": "01",
                        "fc": "13",
                        "fd": "4",
                        "fe": "0",
                        "ff": "0",
                        "fg": "0",
                        "fh": "0",
                        "fi": "06:21|18:23"
                    }
                ],
                "f0": "201503161100"
            }
        }
    }
}
```

返回内容含义：

* spots: 周围其它用户发表的温度信息。geo_near_distance表示距离用户当前位置的距离。其它字段含义参考上传温度信息。
* weather_cn: 从weather cn 中抓取的天气信息，index表示天气指数； forecast表示常规天气预报。其它详细的字段含义请参考weather cn 的api使用说明：http://openweather.weather.com.cn/Public/font/SmartWeatherAPI_Lite_WebAPI_3.0.2.pdf


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
    "email": "734569969@qq.com"
  }
}
```
参数含义：

- email: 用户邮箱，重置密码时用来接收系统发送的验证码。


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
    "email": "734569969@qq.com",
    "password": "88888888",
    "password_confirmation": "88888888",
    "reset_password_token": "QLTWYX"
  }
}
```
参数含义：

- email: 用户邮箱。
- password, password_confirmation: 密码和确认密码
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
    		"email": "734569969@qq.sbb.com",
    		"nick_name": "ssssssbddddbbbb",
    		"gender": 1,
      		"height": 170,
      		"weight": 60,
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










