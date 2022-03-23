(function ($) {
    "use strict";
    // variables
    var header = $(".site-header"),
        wrapper = $('.wrapper');
    // preloader
    preloader();

    function preloader() {
        wrapper.on("click", ".nav__link", function (event) {
            wrapper.removeClass('wrapper_ready-load');
            event.preventDefault();
            var linkLocation = this.href;
            setTimeout(function () {
                window.location = linkLocation;
            }, 500);
        });
        setTimeout(function () {
            wrapper.addClass('wrapper_ready-load');
        }, 0);
    }

    // Sliders init
    // Single slider init
    if ($(".slider").length) {
        $(".slider").slick({
            slidesToShow: 1,
            slidesToScroll: 1,
            infinite: true,
            arrows: true,
            speed: 1000,
            fade: true,
            dots: true,
            prevArrow: '<div class="slick-prev"><svg  class="arrow" width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M16 7H3.83L9.42 1.41L8 0L0 8L8 16L9.41 14.59L3.83 9H16V7Z" fill="#021533"/></svg></div>',
            nextArrow: '<div class="slick-next"><svg class="arrow" width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8 0L6.59 1.41L12.17 7H0V9H12.17L6.59 14.59L8 16L16 8L8 0Z" fill="#021533"/></svg></div>',
            responsive: [
                {
                    breakpoint: 767,
                    settings: {
                        arrows: false,
                        dots: true
                    }
                }
            ]
        });
    }


    // Carousel slider init
    if ($(".carousel__list").length) {
        $(".carousel__list").slick({
            slidesToShow: 1,
            slidesToScroll: 1,
            speed: 1000,
            infinite: true,
            arrows: true,
            variableWidth: true,
            swipeToSlide: true,
            prevArrow: '<div class="slick-prev"><svg  class="arrow" width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M16 7H3.83L9.42 1.41L8 0L0 8L8 16L9.41 14.59L3.83 9H16V7Z" fill="#021533"/></svg></div>',
            nextArrow: '<div class="slick-next"><svg class="arrow" width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8 0L6.59 1.41L12.17 7H0V9H12.17L6.59 14.59L8 16L16 8L8 0Z" fill="#021533"/></svg></div>',
            responsive: [
                {
                    breakpoint: 767,
                    settings: {
                        arrows: false,
                        dots: true
                    }
                }
            ]
        });

    }



    // Carousel slider init
    if ($(".slider_carousel").length) {
        $(".slider_carousel").slick({
            slidesToShow: 4,
            slidesToScroll: 1,
            infinite: true,
            arrows: true,
            speed: 1000,
            dots: true,
            prevArrow: '<div class="slick-prev"><svg  class="arrow" width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M16 7H3.83L9.42 1.41L8 0L0 8L8 16L9.41 14.59L3.83 9H16V7Z" fill="#021533"/></svg></div>',
            nextArrow: '<div class="slick-next"><svg class="arrow" width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8 0L6.59 1.41L12.17 7H0V9H12.17L6.59 14.59L8 16L16 8L8 0Z" fill="#021533"/></svg></div>',
        });

        $('.slider_carousel').on('afterChange', function () {
            setTimeout(function () {
                let sliderWidth = $('.slider_carousel').width(),
                    sliderPosition = $('.slider_carousel').offset().left,
                    maxPosition = sliderWidth + sliderPosition;
                $('.slider_carousel').find(".slider__item").each(function () {
                    let slidePosition = $(this).offset().left;


                    if (slidePosition >= maxPosition) {
                        $(this).css("visibility" , "hidden");
                    }else{
                        $(this).css("visibility" , "visible");
                    }
                });
            }, 0);
        });
    }

    // Mobile menu init
    navInit();
    function navInit() {
        header.find(".burger").on("click", function () {
            $("body").toggleClass("menu-show");
        });
    }

    // companies
    if($(".companies").length){
        companiesFunction();
    }

    function companiesFunction() {
        $(".companies__group").on("click", ".companies__action", function (event) {
            $(this).closest(".companies__group").toggleClass("companies__group_active");
        });
    }

    // footer accordion
    if ($(".widgets__widget").length) {
        accordionInit();
    }

    function accordionInit() {
        $('.widgets__widget').on("click", ".widget__header", function () {
            $(this).closest(".widgets__widget").toggleClass("widgets__widget_active");
        });
    }

    // Section tabs
    tabsInit();

    function tabsInit() {
        let position
            //tabsBodyItem = $(".section__tabs").find(".tabs__item");
        $('.section__action').on("click", ".action__item:not(.skipped)", function () {
            position = $(this).index();
            $(this).addClass("action__item_active").siblings(".action__item").removeClass("action__item_active");
            $(this).parents("section.section:eq(0)").find('.tabs__item.tabs__item_active').removeClass("tabs__item_active");
            $(this).parents("section.section:eq(0)").find('.tabs__item').eq(position).addClass("tabs__item_active")
        });
    }

})(jQuery);