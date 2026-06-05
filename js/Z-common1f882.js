
(function($){
// windows size
var mouseover_tid = [];
var mouseout_tid = [];
var winWidth = 0;
var winHeight = 0;

})(jQuery);



$(function(){
	 var full_height = function()

        {

            if($(window).height() > 590)

            {


            }          

        }

        full_height();

   
   
});




$(document).ready(function(){


		if($('.image-additional ul li').length>1){
				$('.image-additional ul').owlCarousels({
					autoplay:false,
					loop:false,
					margin:0,
					autoplayTimeout:30000,
					smartSpeed:180,
					lazyLoad:true,
					mouseDrag:true,
					slideBy:1,
					responsive: {
								  0: {
									nav: false,
									dots: true,
									items:1,
								  },
								  769: {
									nav: true,
									dots: false,
									items:3,
									
								  }
								}
				});
			}
		else{
			$('.image-additional ul li').addClass('single')
			}

})

