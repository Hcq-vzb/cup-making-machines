$(document).ready(function () {
    var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
    var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1;
    var reIE = new RegExp("MSIE (\\d+\\.\\d+);");
    reIE.test(userAgent);
    var fIEVersion = parseFloat(RegExp["$1"]);
    if (fIEVersion < 9 && isIE) {
        alert('您的浏览器版本为IE' + fIEVersion + ',为了提高您的浏览体验，请对您的浏览器升级！\nYour browser version is IE' + fIEVersion + '. In order to improve your browsing experience, please upgrade your browser!')
    }

    $('#Pop_UpsBtn').click(function () {
        $('#pups_from').fadeIn();
        $('#pups_shadow').fadeIn();
    })

    $('#pups_from i.close').click(function () {
        $('#pups_from').fadeOut();
        $('#pups_shadow').fadeOut();
    })


    if ($(window).width() > 1024) {
        $('.animate-father').filter(function () {
            var sChil = $(this).attr('data-child'),
                sEffect = $(this).attr('data-effect'),
                sDelay = Number($(this).attr('data-delay')),
                initDelay = 0;
            $(this).find(sChil).addClass('wow').addClass(sEffect);
            $(this).find(sChil).filter(function () {
                initDelay += sDelay;
                $(this).attr('data-wow-delay', initDelay + 's');
            });
        });
    }

    $('.counter').countUp();

    if ($(window).scrollTop() >= 300) {
        $('#header').addClass('active');
    }



    if ($(window).width() > 1000) {
        $(window).scroll(function () {
            if ($(window).scrollTop() >= 300) {
                $('#header').addClass("active");
            } else {
                $('#header').removeClass("active");
            }
        })
    }
    $(window).scroll(function () {
        if ($(window).scrollTop() >= 800) {
            $('.go_top').slideDown()
        } else {
            $('.go_top').slideUp()
        }
    });

    if($(window).scrollTop() < 800){
        $('.go_top').hide();
    }


    $('.go_top').click(function () {
        $("html,body").animate({
            scrollTop: 0
        }, 1000);
    })

    $('#header .nav .search').click(function () {
        $('.search-box').fadeIn();
    })

    $('#mobile #menu-on').click(function () {
        if ($('#mobile').hasClass('active')) {
            $('#mobile').removeClass('active');
        } else {
            $('#mobile').addClass('active');
        }
    })

    $('#mobile .menu-content #menu-off').click(function () {
        $('#mobile').removeClass('active');
    })

    new WOW().init();


    if (document.getElementById('ewm')) {
        new QRCode(document.getElementById("ewm"), $("#ewm").attr('data-href') ? $("#ewm").attr('data-href') : window.location.origin);
    }

    $('#header > .nav > .menu .menu-box .right .search').click(function () {
        $('#header .search-box').fadeIn();
    })



    $("#mobile>div").click(function (e) {
        e.stopPropagation()
    });


    var oSerBtn = $('.h-search'),
        oSerBox = $('.search-box'),
        oSerClose = oSerBox.find('.close');
    oSerBtn.click(function () {
        oSerBox.fadeIn();
    });
    oSerClose.click(function () {
        oSerBox.fadeOut();
    });

    var lang = {
        'en': 'English',
        'ru': 'русский',
        'fr': 'Français',
        'la': 'Latine',
        'jp': '日本語',
        'kr': '한국어',
        'vi': 'Tiếng Việt',
        'th': 'ไทย',
        'af': 'Boer (Afrikaans)',
        'sq': 'Shqiptare',
        'am': 'አማርኛ',
        'sa': 'عربى',
        'hy': 'հայերեն',
        'az': 'Azərbaycan dili',
        'eu': 'Euskara',
        'be': 'Беларуская',
        'bn': 'বাংলা',
        'bs': 'Bosanski',
        'bg': 'български',
        'ca': 'Català',
        'ceb': 'Sugbuanon',
        'ny': 'Chichewa',
        'cn': '中文简体',
        'tw': '中文繁体',
        'co': 'Corsu',
        'hr': 'Hrvatski',
        'cs': 'čeština',
        'da': 'dansk',
        'nl': 'Nederlands',
        'eo': 'Esperanto',
        'et': 'Eestlane',
        'tl': 'Pilipino',
        'fi': 'Suomalainen',
        'fy': 'Frysk',
        'gl': 'Galego',
        'ka': 'ქართველი',
        'de': 'Deutsche',
        'el': 'Ελληνικά',
        'gu': 'ગુજરાતી',
        'ht': 'Kreyòl ayisyen',
        'ha': 'Hausa',
        'haw': 'Ōlelo Hawaiʻi',
        'iw': 'עִברִית',
        'hi': 'हिंदी',
        'hmn': 'Hmong',
        'hu': 'Magyar',
        'is': 'Íslenska',
        'ig': 'Igbo',
        'id': 'bahasa Indonesia',
        'ga': 'Gaeilge',
        'it': 'italiano',
        'jw': 'Wong jawa',
        'kn': 'ಕನ್ನಡ',
        'kk': 'Қазақ',
        'km': 'ជនជាតិខ្មែរ',
        'ku': 'Kurdî',
        'ky': 'Кыргызча',
        'lo': 'ລາວ',
        'lv': 'Latvietis',
        'lt': 'Lietuvis',
        'lb': 'Lëtzebuergesch',
        'mk': 'Македонски',
        'mg': 'Malagasy',
        'ms': 'Bahasa Melayu',
        'ml': 'മലയാളം',
        'mt': 'Malti',
        'mi': 'Maori',
        'mr': 'मराठी',
        'mn': 'Монгол',
        'my': 'ဗမာ',
        'ne': 'नेपाली',
        'no': 'norsk',
        'ps': 'پښتو',
        'fa': 'فارسی',
        'pl': 'Polskie',
        'pt': 'Português',
        'pa': 'ਪੰਜਾਬੀ',
        'ro': 'Română',
        'sm': 'Faasamoa',
        'gd': 'Gàidhlig na h-Alba',
        'sr': 'Српски',
        'st': 'Sesotho',
        'sn': 'Shona',
        'sd': 'سنڌي',
        'si': 'සිංහල',
        'sk': 'Slovák',
        'sl': 'Slovenščina',
        'so': 'Soomaali',
        'es': 'Español',
        'su': 'Bahasa Indonesia Bahasa Indonesia',
        'sw': 'Kiswahili',
        'sv': 'svenska',
        'tg': 'Тоҷикӣ',
        'ta': 'தமிழ்',
        'te': 'తెలుగు',
        'tr': 'Türk',
        'uk': 'Український',
        'ur': 'اردو',
        'uz': 'O\'zbek',
        'cy': 'Cymraeg',
        'xh': 'UmXhosa wesiXhosa',
        'yi': 'יידיש',
        'yo': 'Yoruba',
        'zu': 'Zulu waseNingizimu Afrika',
        'fil': 'Pilipino'
    };
    $("ul.lang em").filter(function () {
        $(this).text(lang[$(this).attr('data-name')])
    })


    $("#header > .nav > .menu .lang_cont .c_cont .text").filter(function () {
        $(this).text(lang[$(this).attr('data-name')])
    })


    $(".svg").filter(function () {
        var T = $(this);
        $(this).parent().load($(this).attr('src'));
    })
    $(".play").filter(function () {
        $.plugin.Video_open($(this))
    })

})