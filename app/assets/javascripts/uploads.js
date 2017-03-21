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
          $('.card-cover-avatar').attr('src', result.avatar_url);
          $('.header-nav-avatar').attr('src', result.avatar_url);
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
        });
    }
  });

  /////////////////////////////
  //  Product Images Upload  //
  /////////////////////////////

  $('#product_images').fileupload({

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
          
          var $product_image_delete = $('<a/>', { href: '/product_images/' + result.id, 'data-method': 'delete', 'data-remote': true, 'data-confirm': 'Soovid pildi kustutada?', class: 'form-product-image-delete' }).text('Delete');
          var $product_image = $('<div/>', { class: 'form-product-image', style: "background-image: url('" + result.image_url + "');" }).append($product_image_delete);
          var $product_image_container = $('<div/>', { class: 'form-product-image-container', 'data-id': result.id }).append($product_image);
          var $product_images = $('.form-product-images').append($product_image_container);
          var $product_images_count = $product_images.attr('data-images-count') || 0;
          
          $product_images.attr('data-images-count', parseInt($product_images_count) + 1);

          $product_image_hidden_field = $('<input/>', { 
            type: 'hidden', 
            'data-id': result.id, 
            name: 'product_images[]', 
            value: result.id
          });

          $('.form-hidden-fields').append($product_image_hidden_field);
          $('.form-product-images-btn').removeClass('is-disabled');
          $('.form-product-images-btn-text').text($('.form-product-images-btn-text').attr('data-label'));
        });
    }
  });

});