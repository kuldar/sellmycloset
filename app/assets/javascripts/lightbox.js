////////////////
//  Lightbox  //
////////////////

$(document).on('turbolinks:load', function() {

  var $pswp = $('.pswp')[0];
  var image = [];
  // var $productImages = $("[data-behavior='product-images']");
  // var $productImage = $("[data-behavior='product-image']");

  $("[data-behavior='product-images']").each( function() {
    var $productImages = $(this);
    var getItems = function() {
      var items = [];

      $productImages.find("[data-behavior='product-image']").each(function() {
        var $href   = $(this).attr('href');
        var $size   = $(this).data('size').split('x');
        var $width  = $size[0];
        var $height = $size[1];

        var item = {
          src:  $href,
          w:    $width,
          h:    $height
        }

        items.push(item);
      });

      return items;
    }    

    var items = getItems();

    $.each(items, function(index, value) {
      image[index]     = new Image();
      image[index].src = value['src'];
    });

    $productImages.on('click', "[data-behavior='product-image']", function(event) {
      event.preventDefault();
      console.log('clicked' + $(this).data('index'));
       
      var $index = parseInt($(this).data('index')-1);
      var options = {
        index: $index,
        bgOpacity: 0.7,
        showHideOpacity: true,
        shareEl: false
      }

      var lightBox = new PhotoSwipe($pswp, PhotoSwipeUI_Default, items, options);
      lightBox.init();
    });

  });

});