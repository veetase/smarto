function ifArrow(event){
  event.preventDefault();
  if( event.which=='38') {
    switchPage(-1);
  }else if (event.which=='40') {
    switchPage(1);
  }
}

var init_panel = 1;
function switchPage(num){
  var count = 5;
  init_panel += num;
  current_panel = Math.abs(init_panel % count);

  $(".panel").hide();
  $("#" + current_panel).show();
}

jQuery(document).ready(function($){

  //draw heat map in beijing
  var beijing_heat_config = {
    container: document.getElementById('beijing_heat'),
    radius: 30,
    maxOpacity: 1,
    minOpacity: 0,
    blur: .85,
    gradient: {
      '.2': 'yellow',
      '.8': 'orange',
      '1': 'red'
    }
  };
  var heatmapInstance = h337.create(beijing_heat_config);

  function getRandPointY(){
    var y =  Math.random() * (300 - 110) + 110;
    var x = Math.random() * (150 - 130) + 130;
    var value = Math.random() * 50;
    return {x: x, y: y, value: value}
  }

  function getRandPointX(){
    var y =  Math.random() * (140 - 120) + 120;
    var x = Math.random() * (300 - 120) + 120;
    var value = Math.random() * 50;
    return {x: x, y: y, value: value}
  }
  
  var points= [];
  for (i = 0; i < 20; i++) {
      points.push(getRandPointY());
  }

  for (i = 0; i < 20; i++) {
      points.push(getRandPointX());
  }

  heatmapInstance.addData(points);

  // var data = {
  //   max: 100,
  //   min: 0,
  //   data: [
  //     dataPoint, dataPoint, dataPoint, dataPoint
  //   ]
  // };

  var d = new Date();
  var date = String(d.getFullYear()) + "-" + (d.getMonth() + 1) + "-" + d.getDate();
  var url = "http://wissea.eicp.net:6002/OEairService.asmx/GetHistory?Code=FFFFFFFF00120000&Count=10000&Date=" + date + "&Key="

  Highcharts.setOptions({
    global: {
      useUTC: false
    }
  });
  // Using YQL and JSONP
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
        $('#pm10Min').html(temperMax);
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
  // $.ajax({
  //   type: 'GET',
  //   url: url,
  //   xhrFields: {
  //     withCredentials: false
  //   },
  //   success: function(ret) {
  // 		console.info(ret);
  //   },
  //   error: function() {
  //   }
  // });

});
