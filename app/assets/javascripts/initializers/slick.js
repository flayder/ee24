$(document).ready(function() {    
  $('.news__carousel').slick({
      dots: true,
      arrows: false,
      customPaging: function(slick,index) {
          var image_title = slick.$slides.eq(index).find('img').attr('title') || '';
          return '<p> ' + image_title + '</p>';
      }
  });
});
