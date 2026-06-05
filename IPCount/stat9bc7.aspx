
 
function getUA() {  
    var ua = navigator.userAgent;  
    if (ua.length > 250) {  
        ua = ua.substring(0, 250);  
    }  
    return ua;  
}  

function getBrower() {  
    var ua = getUA();  
    if (ua.indexOf("Maxthon") != -1) {  
        return "Maxthon";  
    } else if (ua.indexOf("MSIE") != -1) {  
        return "MSIE";  
    } else if (ua.indexOf("Firefox") != -1) {  
        return "Firefox";  
    } else if (ua.indexOf("Chrome") != -1) {  
        return "Chrome";  
    } else if (ua.indexOf("Opera") != -1) {  
        return "Opera";  
    } else if (ua.indexOf("Safari") != -1) {  
        return "Safari";  
    } else {  
        return "";  
    }  
} 

function getBrowerLanguage() {  
    var lang = navigator.language;  
    return lang != null && lang.length > 0 ? lang : "";  
}  
  

function getPlatform() {  
    return navigator.platform;  
}

function browserRedirect() {
      var sUserAgent = navigator.userAgent.toLowerCase();
      var bIsIpad = sUserAgent.match(/ipad/i) == "ipad";
      var bIsIphoneOs = sUserAgent.match(/iphone os/i) == "iphone os";
      var bIsMidp = sUserAgent.match(/midp/i) == "midp";
      var bIsUc7 = sUserAgent.match(/rv:1.2.3.4/i) == "rv:1.2.3.4";
      var bIsUc = sUserAgent.match(/ucweb/i) == "ucweb";
      var bIsAndroid = sUserAgent.match(/android/i) == "android";
      var bIsCE = sUserAgent.match(/windows ce/i) == "windows ce";
      var bIsWM = sUserAgent.match(/windows mobile/i) == "windows mobile";
      if (bIsIpad || bIsIphoneOs || bIsMidp || bIsUc7 || bIsUc || bIsAndroid || bIsCE || bIsWM) {
        return "Phone";
      } else {
        return "Pc";
      }
    }
var ys_id = '64';
var ys_ref = document.referrer; 
var ys_page =location.href; 
$.ajax({
    type: "POST",
    url: "/IPCount/IPCount.ashx",
    data: "ID=7728&referrer=" + escape(ys_ref) + "&loca=" + escape(ys_page)
    + "&Ua=" + escape(getBrower())+ "&lan=" + escape(getBrowerLanguage())+ "&sys=" + escape(getPlatform())+ "&PI=" + escape(browserRedirect()),
    success: function (ret) {
             
    }
});

