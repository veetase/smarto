

jQuery(document).ready(function($){
  var gotMachineInfo = false;
  var startingMap = false;

  var weatherTemper;
  var weatherHum;
  var weatherPm25;

  //determine if weatherCn info is better than real info measured by shengmaodou, default is true.
  var betterTemper = true;
  var betterHum = true;
  var betterPm25 = true;

  Highcharts.setOptions({
    global: {
      useUTC: false
    }
  });
  $(document).keydown(function(event) {
    event.preventDefault();
    if( event.which=='38') {
      switchPage(-1);
    }else if (event.which=='40') {
      switchPage(1);
    }
  });

  $(".cd-prev").click(function(){
    switchPage(-1);
  });

  $(".cd-next").click(function(){
    switchPage(1);
  });

  $(document).swipe( {
    //Generic swipe handler for all directions
    swipeUp:function(event, direction, distance, duration, fingerCount) {
      switchPage(1);
    },
    swipeDown:function(event, direction, distance, duration, fingerCount) {
      switchPage(-1);
    }
  });

  var init_panel = 0;
  switchPage(init_panel);
  function switchPage(num){
    var count = 3;
    init_panel += num;
    current_panel = Math.abs(init_panel % count);
    switch(current_panel)
    {
    case 1:
      $(".panel:nth-of-type(" + (current_panel + 1) + ")").show(function(){
        fetchWeather('101280601');

        if(startingMap == false){
          getMapData(updateShenzhenMap);
        }else{
          updateShenzhenMap();
        }
      });
      break;
    case 0:
      $(".panel:nth-of-type(" + (current_panel + 1) + ")").show(function(){
        if(gotMachineInfo == false){
          getMachineInfo();
          gotMachineInfo = true;
        }
      });
      break;
    default:
      $(".panel:nth-of-type(" + (current_panel + 1) + ")").show();
    }
    $(".panel").hide();
    $(".panel:nth-of-type(" + (current_panel + 1) + ")").show();
  }

  function fetchWeather(area_id){
    $.ajax({
        url: ("http://wthrcdn.etouch.cn/WeatherApi?citykey=" + area_id),
        dataType: 'json',
        type: 'GET',
        complete: function (data) {
          var parsedXml = $.parseXML(data["responseText"]);
          var weather = $(parsedXml);
          if(area_id == '101010100'){
            $('#weatherHum').html(weather.find( "shidu" ).text());
            $('#weatherTemper').html((weather.find( "wendu" ).text() + '℃'));
            $('#weatherPm25').html(weather.find( "pm25" ).text());
          }else{
            weatherHum = weather.find( "shidu" ).text();
            weatherTemper = weather.find( "wendu" ).text();
            weatherPm25 = weather.find( "pm25" ).text();
            $('#shenzhenWeatherHum').html(weatherHum);
            $('#shenzhenWeatherTemper').html((weatherTemper + '℃'));
            $('#shenzhenWeatherPm25').html(weatherPm25);

            var fakeHum = Math.random()* 5 + 85;
            var fakeTemp = 20 + Math.random();
            var fakePM = parseFloat(weatherPm25) + Math.random() + 11;
            var fakeVoice = Math.random() * 20 + 20;
            $('#shenzhenDouHum').html(fakeHum.toFixed(2).toString() + '%');
            $('#shenzhendouTemper').html(fakeTemp.toFixed(2).toString() + "℃");
            $('#shenzhendouPm25').html(fakePM.toFixed(2).toString());
            $('#shenzhendouVoice').html(fakeVoice.toFixed(2).toString());
          }
        }
    });
  }

  function updateShenzhenMap(){
    //draw map
    if(current_shenzhen_map == "hum"){
      renderShenzhenMap(current_data["hot_hum"], current_data["cold_hum"], 60, 10, betterHum);
    }else if (current_shenzhen_map == "temp") {
      var use_cold_drawer = weatherTemper <= douTemper;
      renderShenzhenMap(current_data["hot_temp"], current_data["cold_temp"], 70, 10, betterTemper);
    }else if (current_shenzhen_map == "pm25") {
      var use_cold_drawer = weatherPm25 <= douPm25;
      renderShenzhenMap(current_data["hot_pm"], current_data["cold_pm"],  50, 10, betterPm25);
    }else if (current_shenzhen_map == "voice") {
      renderShenzhenMap(current_data["hot_v"], current_data["cold_v"], 60, 10, true);
    }
    setTimeout(updateShenzhenMap, 5000);
  }

  function getMapData(callBack){
    //draw map
    $.ajax({
        url: mapUrl,
        dataType: 'json',
        type: 'GET',
        success: function (data) {
          current_data = data;
          if(startingMap == false){
            startingMap = true;
            callBack();
          }
        }
    });
    setTimeout(getMapData, 5000);
  }
  var mapUrl = '/beijing_show'

  var current_map = "hum";
  var current_shenzhen_map = "hum";
  var current_data = {};

  var humidityTip = ["湿", "中", "干"];
  var temperTip = ["冷", "中", "热"];
  var pm25Tip = ["低", "中", "高"];
  var voiceTip = ["小", "中", "大"];

  function setTip(tips){
    $('.tip:nth-of-type(1)').html(tips[0]);
    $('.tip:nth-of-type(2)').html(tips[1]);
    $('.tip:nth-of-type(3)').html(tips[2]);
  }

  function setCompare(node){
    node.siblings().hide(function(){
      node.show();
    });
  }

  $('.data_mode .mode').click(function(){
    $(this).siblings('.mode').removeClass('active');
    $(this).addClass('active');
  })

  $('#humidityShenzhen').click(function(){
    current_shenzhen_map = "hum";
    setTip(humidityTip); //set top label
    setCompare($('#shenzhenDouHum'));
    setCompare($('#shenzhenWeatherHum'));
    renderShenzhenMap(current_data["hot_hum"], current_data["cold_hum"], 60, 10, betterHum);
  });

  $('#tmperShenzhen').click(function(){
    setTip(temperTip);
    current_shenzhen_map = "temp";
    setCompare($('#shenzhendouTemper'));
    setCompare($('#shenzhenWeatherTemper'));
    renderShenzhenMap(current_data["hot_temp"], current_data["cold_temp"], 70, 10, betterTemper);
  });

  $('#pm25Shenzhen').click(function(){
    setTip(pm25Tip);
    current_shenzhen_map = "pm25";
    setCompare($('#shenzhendouPm25'));
    setCompare($('#shenzhenWeatherPm25'));
    renderShenzhenMap(current_data["hot_pm"], current_data["cold_pm"], 50, 10, betterPm25);
  });

  $('#voiceShenzhen').click(function(){
    setTip(voiceTip);
    current_shenzhen_map = "voice";
    setCompare($('#shenzhendouVoice'));
    setCompare($('#shenzhenWeatherVoice'));
    renderShenzhenMap(current_data["hot_v"], current_data["cold_v"], 60, 10);
  });

  var shenzhen_heat_config = {
    container: document.getElementById('shenzhen_heat'),
    radius: 30,
    maxOpacity: 1,
    minOpacity: 0,
    blur: .55,
    gradient: {
      '.2': 'yellow',
      '.8': 'orange',
      '1': 'red'
    }
  };

  var shenzhen_heat_cold_config = {
    container: document.getElementById('shenzhen_heat'),
    radius: 30,
    maxOpacity: 1,
    minOpacity: 0,
    blur: .85,
    gradient: {
      '.2': '#13AD67',
      '.8': '#00A29A',
      '1': '#036eb8'
    }
  };

  var shenzhenhotmap = false, shenzhencoldmap= false;
  function renderShenzhenMap(data1, data2, value1, value2, use_cold_drawer){
    //draw heat map in shenzhen

    if(shenzhenhotmap == false){
      shenzhenhotmap = h337.create(shenzhen_heat_config);
    }

    if(shenzhencoldmap == false){
      shenzhencoldmap = h337.create(shenzhen_heat_cold_config);
    }

    var mapData = data1;
    $.each(mapData, function(p) {
      mapData[p]['value'] = value1;
    });

    var coldData = data2;
    $.each(coldData, function(p) {
      coldData[p]['value'] = value2;
    });

    var set_data = {
      max: 150,
      min: 0,
      data: mapData
    }

    var set_cold_data = {
      max: 30,
      min: 0,
      data: coldData
    }

    shenzhenhotmap.setData(set_data);
    if (use_cold_drawer){
      shenzhencoldmap.setData(set_cold_data);
    }else{
      shenzhenhotmap.addData(coldData);
    }
  }

  function getMachineInfo(){
    var d = new Date();
    var date = "2015-11-25";
    // var url = "http://wissea.eicp.net:6002/OEairService.asmx/GetHistory?Code=FFFFFFFF00100000&Count=280&Date=" + date + "&Key="
    var url = "http://wissea.eicp.net:6002/OEairService.asmx/GetCurrent?Code=FFFFFFFF00100000&Count=300&Date=" + date + "&Key="

    $.ajax({
        url: url,
        dataType: 'json',
        type: 'GET',
        success: function (data) {
          var content = data["Content"];
          var temperData = fakeLineData("Temperature", 0.2, 1.7, -20, -11);
          var pm25Data = fakeLineData("Temperature", 4, 11, -6, -3);
          var humidityData = getLineData("Humidity", 0.3, 2);
          var CO2Data = getLineData("CO2", 50, -100);
          var VoiceData = getLineData("Voice", 2, -20);
          var lineDataes = {
            temper: {
              data: [
                {
                  data: temperData["temp1"],
                  enableMouseTracking: false,
                  name: '深圳',
                  color: "#8EC31E",
                  lineWidth: 1
                },
                {
                  data: temperData["temp2"],
                  enableMouseTracking: false,
                  name: '学校',
                  color: '#172987',
                  lineWidth: 1
                }
              ],
              format: '℃',
              title: '温度影响舒适度'
            },
            pm25: {
              data: [
                {
                  data: pm25Data["temp1"],
                  enableMouseTracking: false,
                  name: '深圳',
                  color: "#8EC31E",
                  lineWidth: 1
                },
                {
                    data: pm25Data["temp2"],
                    enableMouseTracking: false,
                    name: '学校',
                    color: '#172987',
                    lineWidth: 1
                }
              ],
              format: 'mg/m³',
              title: 'PM2.5影响身体健康'
            },
            CO2: {
              data: [
                {
                  data: CO2Data["temp1"],
                  enableMouseTracking: false,
                  name: '深圳',
                  color: "#8EC31E",
                  lineWidth: 1
                },
                {
                  data: CO2Data["temp2"],
                  enableMouseTracking: false,
                  name: '学校',
                  color: '#172987',
                  lineWidth: 1
                }
              ],
              format: 'ppm',
              title: 'CO₂影响活跃度及专注力'
            },
            voice: {
              data: [
                {
                  data: VoiceData["temp1"],
                  enableMouseTracking: false,
                  name: '深圳',
                  color: "#8EC31E",
                  lineWidth: 1
                },
                {
                  data: VoiceData["temp2"],
                  enableMouseTracking: false,
                  name: '学校',
                  color: '#172987',
                  lineWidth: 1
                }
              ],
              format: 'dB',
              title: '噪音影响专注力'
            }
          };

          var defaultlines = lineDataes["temper"]["data"];
          $('#chart').highcharts({
              chart: {
                  type: 'line',
                  plotBackgroundImage: 'http://7xji8z.com2.z0.glb.qiniucdn.com/background.png'
              },
              xAxis: {
                  type: 'datetime'
              },
              title: {
                  text: '温度影响舒适度'
              },
              legend: {
                  align: 'right',
                  verticalAlign: 'top',
                  itemMarginTop: 20,
                  layout: 'vertical'
              },
              yAxis: {
                  startOnTick: true,
                  labels: {
                      format: '{value}' + lineDataes["temper"]["format"]
                  },
                  title: {
                      text: null
                  },
                  min: 0,
                  gridLineWidth: 0
              },
              series: defaultlines,
              credits: {
                enabled: false
              }
          });

          $(":radio").click(function(){
              var key = $(":checked").val();
              if(key && lineDataes[key]){
                var switchToData = lineDataes[key]["data"];
                if(switchToData.length > 0){
                  $('#chart').highcharts({
                      chart: {
                          type: 'line',
                          plotBackgroundImage: 'http://7xji8z.com2.z0.glb.qiniucdn.com/background.png'
                      },
                      xAxis: {
                          type: 'datetime'
                      },
                      title: {
                          text: lineDataes[key]["title"]
                      },
                      legend: {
                          align: 'right',
                          verticalAlign: 'top',
                          itemMarginTop: 20,
                          layout: 'vertical'
                      },
                      yAxis: {
                        startOnTick: true,
                        labels: {
                            format: '{value}' + lineDataes[key]["format"]
                        },
                        title: {
                            text: null
                        },
                        min: 0,
                        gridLineWidth: 0
                      },
                      series: switchToData,
                      credits: {
                        enabled: false
                      }
                  });
                }
              }
          });

          function getLineData(name, randNum, offset){
            var temp1 = [];
            var temp2 = [];
            content.map(function(obj){
              var point1 = {};

              point1["x"] = (moment(obj["CollectingTime"]).unix() + 9283938) * 1000;
              point1["y"] = obj[name];
              temp1.push(point1);

              var point2 = {};
              point2["x"] = (moment(obj["CollectingTime"]).unix() + 9283938) * 1000;
              point2["y"] = obj[name] + Math.random() * randNum + offset;
              temp2.push(point2);
            });
            return {temp1: temp1, temp2: temp2};
          }

          function fakeLineData(name, randNum1, randNum2, offset1, offset2){
            var temp1 = [];
            var temp2 = [];
            content.map(function(obj){
              var point1 = {};

              point1["x"] = (moment(obj["CollectingTime"]).unix() + 9283938) * 1000;
              point1["y"] = obj[name] + Math.random() * randNum1 + offset1;
              temp1.push(point1);

              var point2 = {};
              point2["x"] = (moment(obj["CollectingTime"]).unix() + 9283938) * 1000;
              point2["y"] = obj[name] + Math.random() * randNum2 + offset2;
              temp2.push(point2);
            });
            return {temp1: temp1, temp2: temp2};
          }
        }
    });
  }
});
