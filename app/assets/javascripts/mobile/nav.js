$(document).ready(function() {
    $('.nav-open').on('click', function() {
        $('header nav').addClass('active');
    })
    $('.nav-close').on('click', function() {
        $('header nav').removeClass('active');
    })
})
