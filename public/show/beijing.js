

jQuery(document).ready(function($){
  var gotMachineInfo = false;
  var startingMap = false;

  $(document).keydown(function(event) {
    event.preventDefault();
    if( event.which=='38') {
      switchPage(-1);
    }else if (event.which=='40') {
      switchPage(1);
    }
  });

  var init_panel = 0;
  function switchPage(num){
    var count = 7;
    init_panel += num;
    current_panel = Math.abs(init_panel % count);

    $(".panel").hide();
    switch(current_panel)
    {
    case 0:
      $(".footer").hide();
      $(".panel:nth-of-type(" + (current_panel + 1) + ")").show();
      break;
    case 1:
      $(".footer").show();
      $(".panel:nth-of-type(" + (current_panel + 1) + ")").show();
      break;
    case 2:
      $(".panel:nth-of-type(" + (current_panel + 1) + ")").show(function(){
        if(startingMap == false){
          getMapData(updateMap);
          updateDouInfo();
          updateShenzhenDouInfo();
        }else{
          updateMap();
        }

        fetchWeather('101010100');
      });
      break;
    case 3:
      $(".panel:nth-of-type(" + (current_panel + 1) + ")").show(function(){
        if(gotMachineInfo == false){
          getMachineInfo();
          gotMachineInfo = true;
        }
      });
      break;
    case 5:
      //shenzhen map
      $(".panel:nth-of-type(" + (current_panel + 1) + ")").show(function(){
        if(startingMap == false){
          getMapData(updateShenzhenMap);
        }else{
          updateShenzhenMap();
        }
        fetchWeather('101280601');
      });

      break;
    case 6:
      $(".footer").show();
      $(".panel:nth-of-type(" + (current_panel + 1) + ")").show();
      break;
    default:
      $(".panel:nth-of-type(" + (current_panel + 1) + ")").show();
    }
  }

  function updateDouInfo(){
    //compare shengmaodou and china weather info
    $.ajax({
        url: "http://wissea.eicp.net:6002/OEairService.asmx/GetData?Code=FFFFFFFF00120000&Key=",
        dataType: 'json',
        type: 'GET',
        success: function (data) {
          $('#douHum').html((data['Content'][0]['Humidity'] + "%"));
          $('#douTemper').html((data['Content'][0]['Temperature'] + "℃"));
          $('#douPm25').html(data['Content'][0]['PM2.5']);
          $('#douVoice').html(data['Content'][0]['Voice']);
        }
    });

    setTimeout(updateDouInfo, 5000);
  }

  function updateShenzhenDouInfo(){
    //compare shengmaodou and china weather info
    $.ajax({
        url: "http://wissea.eicp.net:6002/OEairService.asmx/GetData?Code=FFFFFFFF00100000&Key=",
        dataType: 'json',
        type: 'GET',
        success: function (data) {
          $('#shenzhenDouHum').html((data['Content'][0]['Humidity'] + "%"));
          $('#shenzhendouTemper').html((data['Content'][0]['Temperature'] + "℃"));
          $('#shenzhendouPm25').html(data['Content'][0]['PM2.5']);
          $('#shenzhendouVoice').html(data['Content'][0]['Voice']);
        }
    });

    setTimeout(updateShenzhenDouInfo, 5000);
  }

  // get Weather info from internet
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
            $('#shenzhenWeatherHum').html(weather.find( "shidu" ).text());
            $('#shenzhenWeatherTemper').html((weather.find( "wendu" ).text() + '℃'));
            $('#shenzhenWeatherPm25').html(weather.find( "pm25" ).text());
          }
        }
    });
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

  function updateMap(){
    //draw map
    if(current_map == "hum"){
      renderMap(current_data["beijing_as"].concat(current_data["beijing_bs"]), current_data["beijing_cs"], current_data["beijing_ds"], 40, 20, 6);
    }else if (current_map == "temp") {
      renderMap(current_data["beijing_a"].concat(current_data["beijing_b"]), current_data["beijing_c"], current_data["beijing_d"], 60, 20, 3);
    }else if (current_map == "pm25") {
      renderMap(current_data["beijing_apm"].concat(current_data["beijing_bpm"]), current_data["beijing_cpm"], current_data["beijing_dpm"], 30, 40, 5);
    }else if (current_map == "voice") {
      renderMap(current_data["beijing_av"].concat(current_data["beijing_bv"]), current_data["beijing_cv"], current_data["beijing_dv"], 40, 30, 5);
    }
    setTimeout(updateMap, 5000);
  }

  function updateShenzhenMap(){
    //draw map
    if(current_shenzhen_map == "hum"){
      renderShenzhenMap(current_data["shenzhen_cs"].concat(current_data["shenzhen_bs"]), current_data["shenzhen_as"], 40, 6);
    }else if (current_shenzhen_map == "temp") {
      renderShenzhenMap(current_data["shenzhen_c"].concat(current_data["shenzhen_b"]), current_data["shenzhen_a"], 40, 3);
    }else if (current_shenzhen_map == "pm25") {
      renderShenzhenMap(current_data["shenzhen_cpm"].concat(current_data["shenzhen_bpm"]), current_data["shenzhen_apm"],  30, 5);
    }else if (current_shenzhen_map == "voice") {
      renderShenzhenMap(current_data["shenzhen_cv"].concat(current_data["shenzhen_bv"]), current_data["shenzhen_av"], 40, 5);
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

  $('#humidityRound').click(function(){
    current_map = "hum";
    setTip(humidityTip); //set top label
    setCompare($('#douHum'));
    setCompare($('#weatherHum'));
    renderMap(current_data["beijing_as"].concat(current_data["beijing_bs"]), current_data["beijing_cs"], current_data["beijing_ds"], 40, 20, 6);
  });

  $('#tmperRound').click(function(){
    setTip(temperTip);
    current_map = "temp";
    setCompare($('#douTemper'));
    setCompare($('#weatherTemper'));
    renderMap(current_data["beijing_a"].concat(current_data["beijing_b"]), current_data["beijing_c"], current_data["beijing_d"], 60, 20, 3);
  });
  $('#pm25Round').click(function(){
    setTip(pm25Tip);
    current_map = "pm25";
    setCompare($('#douPm25'));
    setCompare($('#weatherPm25'));
    renderMap(current_data["beijing_apm"].concat(current_data["beijing_bpm"]), current_data["beijing_cpm"], current_data["beijing_dpm"], 30, 40, 5);
  });

  $('#voiceRound').click(function(){
    setTip(voiceTip);
    current_map = "voice";
    setCompare($('#douVoice'));
    setCompare($('#weatherVoice'));
    renderMap(current_data["beijing_av"].concat(current_data["beijing_bv"]), current_data["beijing_cv"], current_data["beijing_dv"], 40, 30, 5);
  });

  $('#humidityShenzhen').click(function(){
    current_shenzhen_map = "hum";
    setTip(humidityTip); //set top label
    setCompare($('#shenzhenDouHum'));
    setCompare($('#shenzhenWeatherHum'));
    renderShenzhenMap(current_data["shenzhen_cs"].concat(current_data["shenzhen_bs"]), current_data["shenzhen_as"], 40, 6);
  });

  $('#tmperShenzhen').click(function(){
    setTip(temperTip);
    current_shenzhen_map = "temp";
    setCompare($('#shenzhendouTemper'));
    setCompare($('#shenzhenWeatherTemper'));
    renderShenzhenMap(current_data["shenzhen_c"].concat(current_data["shenzhen_b"]), current_data["shenzhen_a"], 40, 3);
  });

  $('#pm25Shenzhen').click(function(){
    setTip(pm25Tip);
    current_shenzhen_map = "pm25";
    setCompare($('#shenzhendouPm25'));
    setCompare($('#shenzhenWeatherPm25'));
    renderShenzhenMap(current_data["shenzhen_cpm"].concat(current_data["shenzhen_bpm"]), current_data["shenzhen_apm"], 30, 5);
  });

  $('#voiceShenzhen').click(function(){
    setTip(voiceTip);
    current_shenzhen_map = "voice";
    setCompare($('#shenzhendouVoice'));
    setCompare($('#shenzhenWeatherVoice'));
    renderShenzhenMap(current_data["shenzhen_cv"].concat(current_data["shenzhen_bv"]), current_data["shenzhen_av"], 40, 5);
  });

  // render humidity heatmap by default
  var beijing_heat_config = {
    container: document.getElementById('beijing_heat'),
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

  var beijing_heat_cold_config = {
    container: document.getElementById('beijing_heat'),
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

  var hotmap = false, coldmap = false, shenzhenhotmap = false, shenzhencoldmap= false;

  function renderMap(data1, data2, data3, value1, value2, value3){
    //draw heat map in beijing

    if(hotmap == false){
      hotmap = h337.create(beijing_heat_config);
    }

    if(coldmap == false){
      coldmap = h337.create(beijing_heat_cold_config);
    }

    var mapData = data1;
    $.each(mapData, function(p) {
      mapData[p]['value'] = value1;
    });

    var doorData = data2;
    $.each(doorData, function(p) {
      doorData[p]['value'] = value2;
    });

    var coldData = data3;
    $.each(coldData, function(p) {
      coldData[p]['value'] = value3;
    });

    var finalData = mapData.concat(doorData);
    var set_data = {
      max: 150,
      min: 0,
      data: finalData
    }

    var set_cold_data = {
      max: 30,
      min: 0,
      data: coldData
    }

    hotmap.setData(set_data);
    coldmap.setData(set_cold_data);
  }

  function renderShenzhenMap(data1, data2, value1, value2){
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
    shenzhencoldmap.setData(set_cold_data);
  }

  // var data = {
  //   max: 100,
  //   min: 0,
  //   data: [
  //     dataPoint, dataPoint, dataPoint, dataPoint
  //   ]
  // };



  Highcharts.setOptions({
    global: {
      useUTC: false
    }
  });

  // Using YQL and JSONP
  function getMachineInfo(){
    var d = new Date();
    var date = String(d.getFullYear()) + "-" + (d.getMonth() + 1) + "-" + d.getDate();
    var url = "http://wissea.eicp.net:6002/OEairService.asmx/GetHistory?Code=FFFFFFFF00120000&Count=10000&Date=" + date + "&Key="

    $.ajax({
        url: url,
        dataType: 'json',
        type: 'GET',
        success: function (data) {
          content = data["Content"]
          var temperData = content.map(function(obj){
            var temp = {};
            temp["x"] = moment(obj["CollectingTime"]).unix() * 1000;
            temp["y"] = obj["Temperature"] / 20 ;
            return temp;
          });

          var temperMax = Math.max.apply(null, content.map(function(obj){
            return obj["Temperature"];
          }));

          var temperMin = Math.min.apply(null, content.map(function(obj){
            return obj["Temperature"];
          }));

          var humidityData = content.map(function(obj){
            var temp = {};
            temp["x"] = moment(obj["CollectingTime"]).unix() * 1000;
            temp["y"] = obj["Humidity"] / 60 ;
            return temp;
          });

          var humMax = Math.max.apply(null, content.map(function(obj){
            return obj["Humidity"];
          }));

          var humMin = Math.min.apply(null, content.map(function(obj){
            return obj["Humidity"];
          }));

          var PM25Data = content.map(function(obj){
            var temp = {};
            temp["x"] = moment(obj["CollectingTime"]).unix() * 1000;
            temp["y"] = obj["PM2.5"] / 80 ;
            return temp;
          });

          var pm25Max = Math.max.apply(null, content.map(function(obj){
            return obj["PM2.5"];
          }));

          var pm25Min = Math.min.apply(null, content.map(function(obj){
            return obj["PM2.5"];
          }));
          var PM10Data = content.map(function(obj){
            var temp = {};
            temp["x"] = moment(obj["CollectingTime"]).unix() * 1000;
            temp["y"] = obj["PM10"] / 90 ;
            return temp;
          });
          var pm10Max = Math.max.apply(null, content.map(function(obj){
            return obj["PM10"];
          }));

          var pm10Min = Math.min.apply(null, content.map(function(obj){
            return obj["PM10"];
          }));
          var voiceData = content.map(function(obj){
            var temp = {};
            temp["x"] = moment(obj["CollectingTime"]).unix() * 1000;
            temp["y"] = obj["Voice"] / 20 ;
            return temp;
          });
          var voiceMax = Math.max.apply(null, content.map(function(obj){
            return obj["Voice"];
          }));

          var voiceMin = Math.min.apply(null, content.map(function(obj){
            return obj["Voice"];
          }));

          var CO2Data = content.map(function(obj){
            var temp = {};
            temp["x"] = moment(obj["CollectingTime"]).unix() * 1000;
            temp["y"] = obj["CO2"] / 400 ;
            return temp;
          });
          var co2Max = Math.max.apply(null, content.map(function(obj){
            return obj["CO2"];
          }));

          var co2Min = Math.min.apply(null, content.map(function(obj){
            return obj["CO2"];
          }));

          $('#temperMax').html(temperMax);
          $('#temperMin').html(temperMin);
          $('#humMax').html(humMax);
          $('#humMin').html(humMin);
          $('#pm25Max').html(pm25Max);
          $('#pm25Min').html(pm25Min);
          $('#pm10Max').html(temperMax);
          $('#pm10Min').html(temperMin);
          $('#voiceMax').html(voiceMax);
          $('#voiceMin').html(voiceMin);
          $('#co2Max').html(co2Max);
          $('#co2Min').html(co2Min);

          var dataes = {
            temper: {
              data: temperData,
              enableMouseTracking: false,
              name: '温度',
              color: "#8EC31E",
              lineWidth: 1
            },
            humidity:	{
              data: humidityData,
              enableMouseTracking: false,
              name: '湿度',
              color: '#172987',
              lineWidth: 1
            },
            pm25: {
              data: PM25Data,
              enableMouseTracking: false,
              name: 'PM2.5',
              color: '#51ABCB',
              lineWidth: 1
            },
            pm10: {
              data: PM10Data,
              enableMouseTracking: false,
              name: 'PM10',
              color: '#F2C75B',
              lineWidth: 1
            },
            co2: {
              data: CO2Data,
              enableMouseTracking: false,
              name: 'CO₂',
              color: '#E9544F',
              lineWidth: 1
            },
            voice: {
              data: voiceData,
              enableMouseTracking: false,
              name: '噪声',
              color: '#D8234E',
              lineWidth: 1
            },
          };

          var init_data = [];
          $.each(dataes, function(key, val) {
            init_data.push(val);
          });

          $(":checkbox").click(function(){
            var checked_data = [];
            $(":checked").each(function(){
              var key = $(this).attr("name");
              if(key && dataes[key]){
                checked_data.push(dataes[key]);
                if(checked_data.length > 0){
                  $('#chart').highcharts({
                      chart: {
                          type: 'line'
                      },
                      xAxis: {
                          type: 'datetime'
                      },
                      title: {
                          text: null
                      },
                      legend: {
                          align: 'right',
                          verticalAlign: 'top',
                          itemMarginTop: 20,
                          layout: 'vertical'
                      },
                      yAxis: {
                          startOnTick: false,
                          labels: {
                              enabled: false
                          },
                          title: {
                              text: null
                          },
                          gridLineWidth: 0
                      },
                      series: checked_data,
                      credits: {
                        enabled: false
                      }
                  });
                }
              }
            })
          });

          $('#chart').highcharts({
              chart: {
                  type: 'line'
              },
              xAxis: {
                  type: 'datetime'
              },
              title: {
                  text: null
              },
              legend: {
                  align: 'right',
                  verticalAlign: 'top',
                  itemMarginTop: 20,
                  layout: 'vertical'
              },
              yAxis: {
                  startOnTick: false,
                  labels: {
                      enabled: false
                  },
                  title: {
                      text: null
                  },
                  gridLineWidth: 0
              },
              series: init_data,
              credits: {
                enabled: false
              }
          });
        }
    });
  }
});
