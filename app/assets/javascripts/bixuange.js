//= require jquery
//= require jquery_ujs
//= require jquery.flip
$(document).ready(function(){
  $(".card").flip();
})

$(window).scroll(function() {
    var height = $(window).scrollTop(); //有数值显示

    var projectHeight = document.getElementById('project').offsetTop;
    var memberHeight = document.getElementById('member').offsetTop;
    var blogHeight = document.getElementById('blog').offsetTop;
    var managementHeight = document.getElementById('management').offsetTop;
    var cultureHeight = document.getElementById('culture').offsetTop;


    if (height < projectHeight) {
    	document.getElementById('navEnglishDescription').innerHTML = ' ';

    	document.getElementById("projectNavTopText").style.color = "#fbf9e5";
		document.getElementById("memberNavTopText").style.color = "#fbf9e5";
		document.getElementById("blogNavTopText").style.color = "#fbf9e5";
    	document.getElementById("managementNavTopText").style.color = "#fbf9e5";
    	document.getElementById("cultureNavTopText").style.color = "#fbf9e5";

		document.getElementById("projectNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("projectNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    	document.getElementById("memberNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("memberNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    	document.getElementById("blogNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("blogNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    	document.getElementById("managementNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("managementNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    	document.getElementById("cultureNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("cultureNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";

    }else if (height >= projectHeight && height < memberHeight) {
    	document.getElementById('navEnglishDescription').innerHTML = 'PROJECT';
    	document.getElementById("projectNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftRed-0e5b7a2f2877ecbeb65f7d76ac0474cd.png";
    	document.getElementById("projectNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightRed-7a7bd47aa9cb8e220d4a32718f2f9b24.png";
    	document.getElementById("projectNavTopText").style.color = "#c00";

		document.getElementById("memberNavTopText").style.color = "#fbf9e5";
		document.getElementById("blogNavTopText").style.color = "#fbf9e5";
    	document.getElementById("managementNavTopText").style.color = "#fbf9e5";
    	document.getElementById("cultureNavTopText").style.color = "#fbf9e5";

    	document.getElementById("memberNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("memberNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    	document.getElementById("blogNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("blogNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    	document.getElementById("managementNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("managementNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    	document.getElementById("cultureNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("cultureNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    }else if (height >= memberHeight && height < blogHeight) {
    	document.getElementById('navEnglishDescription').innerHTML = 'MEMBER & CONTACT';
    	document.getElementById("memberNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftRed-0e5b7a2f2877ecbeb65f7d76ac0474cd.png";
    	document.getElementById("memberNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightRed-7a7bd47aa9cb8e220d4a32718f2f9b24.png";
    	document.getElementById("memberNavTopText").style.color = "#c00";

    	document.getElementById("projectNavTopText").style.color = "#fbf9e5";
		document.getElementById("blogNavTopText").style.color = "#fbf9e5";
    	document.getElementById("managementNavTopText").style.color = "#fbf9e5";
    	document.getElementById("cultureNavTopText").style.color = "#fbf9e5";

    	document.getElementById("projectNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("projectNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    	document.getElementById("blogNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("blogNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    	document.getElementById("managementNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("managementNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    	document.getElementById("cultureNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("cultureNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    }else if (height >= blogHeight && height < managementHeight) {
    	document.getElementById('navEnglishDescription').innerHTML = 'BLOG & SUBSCRIBE';
    	document.getElementById("blogNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftRed-0e5b7a2f2877ecbeb65f7d76ac0474cd.png";
    	document.getElementById("blogNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightRed-7a7bd47aa9cb8e220d4a32718f2f9b24.png";
    	document.getElementById("blogNavTopText").style.color = "#c00";

    	document.getElementById("projectNavTopText").style.color = "#fbf9e5";
		document.getElementById("memberNavTopText").style.color = "#fbf9e5";
    	document.getElementById("managementNavTopText").style.color = "#fbf9e5";
    	document.getElementById("cultureNavTopText").style.color = "#fbf9e5";

    	document.getElementById("projectNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("projectNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    	document.getElementById("memberNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("memberNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    	document.getElementById("managementNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("managementNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    	document.getElementById("cultureNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("cultureNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    }else if (height >= managementHeight && height < cultureHeight) {
    	document.getElementById('navEnglishDescription').innerHTML = 'MANAGEMENT';
    	document.getElementById("managementNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftRed-0e5b7a2f2877ecbeb65f7d76ac0474cd.png";
    	document.getElementById("managementNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightRed-7a7bd47aa9cb8e220d4a32718f2f9b24.png";
    	document.getElementById("managementNavTopText").style.color = "#c00";

    	document.getElementById("projectNavTopText").style.color = "#fbf9e5";
		document.getElementById("memberNavTopText").style.color = "#fbf9e5";
		document.getElementById("blogNavTopText").style.color = "#fbf9e5";
    	document.getElementById("cultureNavTopText").style.color = "#fbf9e5";

    	document.getElementById("projectNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("projectNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    	document.getElementById("memberNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("memberNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    	document.getElementById("blogNavTopBracketLeft").src = "/assets//static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("blogNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    	document.getElementById("cultureNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("cultureNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    }else if (height >= cultureHeight) {
    	document.getElementById('navEnglishDescription').innerHTML = 'CULTURE';
    	document.getElementById("cultureNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftRed-0e5b7a2f2877ecbeb65f7d76ac0474cd.png";
    	document.getElementById("cultureNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightRed-7a7bd47aa9cb8e220d4a32718f2f9b24.png";
    	document.getElementById("cultureNavTopText").style.color = "#c00";

    	document.getElementById("projectNavTopText").style.color = "#fbf9e5";
		document.getElementById("memberNavTopText").style.color = "#fbf9e5";
		document.getElementById("blogNavTopText").style.color = "#fbf9e5";
    	document.getElementById("managementNavTopText").style.color = "#fbf9e5";

    	document.getElementById("projectNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("projectNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    	document.getElementById("memberNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("memberNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    	document.getElementById("blogNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("blogNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    	document.getElementById("managementNavTopBracketLeft").src = "/assets/static_page/brackets/bracket2LeftWhite-b47105d1bc8e0c0680953780f52d69d5.png";
    	document.getElementById("managementNavTopBracketRight").src = "/assets/static_page/brackets/bracket2RightWhite-33bb52ca39a9508f0bc2823ec9f8ab5e.png";
    };

});
