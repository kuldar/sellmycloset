$(document).on('turbolinks:load', function() {

  ////////////////////
  //  Format Image  //
  ////////////////////
  function formatImage(data) {
    var formattedImage = {
      id: data.formData.key.match(/cache\/(.+)/)[1], // have to remove the prefix
      storage: 'cache',
      metadata: {
        size:       data.files[0].size,
        filename:   data.files[0].name.match(/[^\/\\]+$/)[0], // IE, return full path
        mime_type:  data.files[0].type
      }
    };

    return formattedImage;
  }

  function presign(data, url) {
    var options = { extensions: data.files[0].name.match(/(\.\w+)?$/)[0], _: Date.now() }

    $.getJSON(url, options, function(result) {
      data.formData = result['fields'];
      data.url = result['url'];
      data.paramName = 'file';
      data.submit();
    });
  }

  /////////////////////
  //  Avatar Upload  //
  /////////////////////

  $('#user_avatar').fileupload({

    add: function(e, data) {
      data.progressBar = $('<div class="progress"><div class="progress-bar"></div></div>').insertAfter('.card-cover');
      presign(data, '/avatars/upload/cache/presign');
    },

    progress: function(e, data) {
      var percentage = parseInt(data.loaded / data.total * 100, 10).toString() + '%';
      data.progressBar.find('.progress-bar').css('width', percentage);
    },

    done: function(e, data) {
      data.progressBar.remove();

      var image = formatImage(data);
      var params = { user: { avatar: JSON.stringify(image) } }

      $.ajax('/users/avatar', { method: 'PUT', data: params })
        .done(function(result) {
          var $card_cover_avatar = $('<img/>', { class: 'card-cover-avatar', src: result.avatar_url });
          $('.card-cover-avatar-container').html($card_cover_avatar);

          var $header_nav_avatar = $('<img/>', { class: 'header-nav-avatar', src: result.avatar_url });
          $('.header-nav-user').html($header_nav_avatar);
        });
    }
  });

  ////////////////////
  //  Cover Upload  //
  ////////////////////

  $('#user_cover').fileupload({

    add: function(e, data) {
      data.progressBar = $('<div class="progress"><div class="progress-bar"></div></div>').insertAfter('.card-cover');
      presign(data, '/covers/upload/cache/presign');
    },

    progress: function(e, data) {
      var percentage = parseInt(data.loaded / data.total * 100, 10).toString() + '%';
      data.progressBar.find('.progress-bar').css('width', percentage);
    },

    done: function(e, data) {
      data.progressBar.remove();

      var image = formatImage(data);
      var params = { user: { cover: JSON.stringify(image) } }

      $.ajax('/users/cover', { method: 'PUT', data: params })
        .done(function(result) {
          $('.card-cover').attr('style', "background-image: url('" + result.cover_url + "');" );
          $('.card-cover').addClass('has-bg');
        });
    }
  });

  /////////////////////////////
  //  Product Images Upload  //
  /////////////////////////////

  $('#product_images').fileupload({

    change: function (e, data) {
      var $product_images_limit = 5;
      var $product_images_count = $("[data-behavior='form-product-images']").attr('data-images-count');
      var $product_images_slots = $product_images_limit - $product_images_count;

      if (data.files.length > $product_images_slots){
        alert($('#product_images').attr('data-label-limit'));
        return false;
      }
    },

    add: function(e, data) {
      data.progressBar = $('<div class="progress"><div class="progress-bar"></div></div>').insertAfter('.header');
      presign(data, '/productimages/upload/cache/presign');
      $('.form-product-images-btn').addClass('is-disabled');
      $('.form-product-images-btn-text').text($('.form-product-images-btn-text').attr('data-label-disabled'));
    },

    progress: function(e, data) {
      var percentage = parseInt(data.loaded / data.total * 100, 10).toString() + '%';
      data.progressBar.find('.progress-bar').css('width', percentage);
    },

    done: function(e, data) {
      data.progressBar.remove();

      var image = formatImage(data);
      var params = { product_image: { image: JSON.stringify(image) } }

      $.ajax('/product_images', { method: 'POST', data: params })
        .done(function(result) {
          
          var $product_image_delete = $('<a/>', { href: '/product_images/' + result.id, 'data-method': 'delete', 'data-remote': true, 'data-confirm': $('#product_images').attr('data-label-delete-confirm'), class: 'grid-image-delete' }).text($('#product_images').attr('data-label-delete'));
          var $product_image = $('<div/>', { class: 'grid-image', style: "background-image: url('" + result.image_url + "');" }).append($product_image_delete);
          var $product_image_container = $('<div/>', { class: 'grid-image-container', 'data-id': result.id }).append($product_image);
          var $product_images = $('.grid-images').append($product_image_container);
          var $product_images_count = $product_images.attr('data-images-count') || 0;
          
          $new_product_images_count = parseInt($product_images_count) + 1;
          $product_images.attr('data-images-count', $new_product_images_count);

          $product_image_hidden_field = $('<input/>', { 
            type: 'hidden', 
            'data-id': result.id, 
            name: 'product_images[]', 
            value: result.id
          });

          $('.form-hidden-fields').append($product_image_hidden_field);

          if ($new_product_images_count < 5) {
            $('.form-product-images-btn').removeClass('is-disabled');
            $('.form-product-images-btn-text').text($('.form-product-images-btn-text').attr('data-label'));
          } else {
            $('.form-product-images-btn').addClass('is-disabled');
            $('.form-product-images-btn-text').text($('#product_images').attr('data-label-limit'));
          }
        });
    }
  });

});