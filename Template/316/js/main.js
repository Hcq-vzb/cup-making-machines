;$(function(){


     new Swiper ('#banner .container .swiper', {
        speed: 1500,
        effect : 'fade',
        loop:true,

        autoplay: {
            disableOnInteraction: false,
            delay: 5000,
        },

        pagination: {
            el: '#banner .container .swiper-pagination',
        },

        navigation: {
            nextEl: '#banner .container .s_page',
            prevEl: '#banner .container .prev',
        },

        on: {

            slideChangeTransitionStart: function(){

                if($('#banner .container .s_page .subline_c div').hasClass('banner_ani')){
                    $('#banner .container .s_page .subline_c div').removeClass('banner_ani');
                    $('#banner .container .s_page .subline_c div').addClass('banner_ani_2');
                }else{
                    $('#banner .container .s_page .subline_c div').removeClass('banner_ani_2');
                    $('#banner .container .s_page .subline_c div').addClass('banner_ani');
                }
                var wow_banner = new WOW({
                    boxClass: 'wow_banner',
                    animateClass: 'animated',
                    offset: 0,
                    mobile: true,
                    live: true
                });

                wow_banner.init();
            
            },
        },
    }) 



    new Swiper ('#index-body .init-3 .container .swiper', {
        speed:1500,
        autoplay:true,
        loop:true,


        navigation: {
            nextEl: '#index-body .init-3 .container .next',
            prevEl: '#index-body .init-3 .container .prev',
        },

        
        breakpoints: {
            300: {
                slidesPerView: 1,
                spaceBetween: 20,
            },
            500: {
                slidesPerView: 1.2,
                spaceBetween: 10,
                centeredSlides: true,
            },
            700: {
                slidesPerView: 1.3,
                spaceBetween: 10,
                centeredSlides: true,
            },
            1000: {
                slidesPerView: 2,
                spaceBetween: 60,
                centeredSlides: true,
            },

            1500: {
                slidesPerView: 1.7,
                spaceBetween: 70,
                centeredSlides: true,
            },
            
        },

      
    })


    new Swiper ('#index-body .init-5 .container .swiper', {
        speed:1500,
        autoplay:true,
        navigation: {
            nextEl: '#index-body .init-5 .container .next',
            prevEl: '#index-body .init-5 .container .prev',
        },

        breakpoints: {
            300: {
                slidesPerView: 1,
                spaceBetween: 20,
            },
            500: {
                slidesPerView: 2,
                spaceBetween: 20,
            },
            700: {
                slidesPerView: 2,
                spaceBetween: 30,
            },
            1000: {
                slidesPerView: 3,
                spaceBetween: 30,
            },

            1500: {
                slidesPerView: 3,
                spaceBetween: 30,
            },
            
        },

      
    })


    new Swiper ('#index-body .init-9 .container .swiper', {
        speed:1500,
        autoplay:true,

        breakpoints: {
            300: {
                slidesPerView: 1,
                spaceBetween: 20,
            },
            500: {
                slidesPerView: 2,
                spaceBetween: 10,
            },
            700: {
                slidesPerView: 2,
                spaceBetween: 20,
            },
            1000: {
                slidesPerView: 3,
                spaceBetween: 60,
            },

            1500: {
                slidesPerView: 3,
                spaceBetween: 60,
            },
            
        },
      
    })


    if($('#index-body .init-2 .contain').length){
        $.plugin.NUMBER_plus($("#index-body .init-2 .contain .container"),30);
    }
    // inner-page




});

$(window).scroll(function() {
    var a = $(window).height() / 3;
    $(window).scrollTop() > a ? $(".back_top").show() : $(".back_top").hide()
}),

$(".back_top").click(function() {
    var a = 700;
    return $("body,html").animate({
        scrollTop: 0
    },
    a),
    !1
})

$(document).ready(function() {
	$(".mob-yuy:not(.lang-switch-mobile) h3").click(function(){
	$(".mob-yuy h3").toggleClass("lon");
	$(".lang").toggleClass("langoff");
	});
	$('#mobile .fa-mobile-down').on('click',function(){
	$(this).siblings().stop(false,true).parents('li').toggleClass('mon');
	$(this).parents('li').siblings().removeClass('mon').find('.sub-menu').slideUp();
	});  });
