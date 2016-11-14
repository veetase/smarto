$(function() {	

	//开始加载出现效果
	var options = {
		useEasing:true,
		useGrouping:true,
		seperator:',',
		decimal:'.',
		prefix:'24',
		suffix:'',
	};
	var demo = new CountUp("star",0,23846,0,600,options);
	demo.start();
	//end 开始加载出现效果
})