
		    var mySwiperm1 = new Swiper ('.Recommendations .swiper-container', {
				slidesPerView: 4,
				slidesPerGroup: 1,
				spaceBetween: 0,
				lazy: true,
				autoplay:true,
				breakpoints: {
					1024: {
						slidesPerView: 3,
						slidesPerGroup: 1,
						spaceBetween: 0,
					},
					768: {
						slidesPerView: 2,
						slidesPerGroup: 1,
						spaceBetween: 0,
					},
					640: {
						slidesPerView: 2,
						slidesPerGroup: 1,
						spaceBetween: 0,
					},
					500: {
						slidesPerView: 1,
						slidesPerGroup: 1,
						spaceBetween: 0,
					}
				},
				navigation: {
					prevEl: '.Recommendations .swiper-button-prev',
					nextEl: '.Recommendations .swiper-button-next',
				}
			})
			
			
			     var mySwiperm2 = new Swiper ('.Related .swiper-container', {
				slidesPerView: 4,
				slidesPerGroup: 1,
				spaceBetween: 0,
				lazy: true,
				autoplay:true,
				breakpoints: {
					1024: {
						slidesPerView: 3,
						slidesPerGroup: 1,
						spaceBetween: 0,
					},
					768: {
						slidesPerView: 2,
						slidesPerGroup: 1,
						spaceBetween: 0,
					},
					640: {
						slidesPerView: 2,
						slidesPerGroup: 1,
						spaceBetween: 0,
					},
					500: {
						slidesPerView: 1,
						slidesPerGroup: 1,
						spaceBetween: 0,
					}
				},
				navigation: {
					prevEl: '.Related .swiper-button-prev',
					nextEl: '.Related .swiper-button-next',
				}
			})