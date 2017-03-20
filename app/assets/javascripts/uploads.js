$(document).on('turbolinks:load', function() {

  // Avatar Upload
  // $('[input=file]').fileupload({
  $('#user_avatar').fileupload({
    add: function(e, data) {
      console.log('add', data);
      data.progressBar = $('<div class="progress" style="width:300px"><div class="progress-bar"></div></div>').insertAfter('.card-cover');
      var options = {
        extensions: data.files[0].name.match(/(\.\w+)?$/)[0], // set the file extension
        _: Date.now()  // prevent caching
      }

      $.getJSON('/covers/upload/cache/presign', options, function(result) {
        console.log('presign', result);
        data.formData = result['fields'];
        data.url = result['url'];
        data.paramName = 'file';
        data.submit();
      });
    },
    progress: function(e, data) {
      console.log('progress', data);

      var progress = parseInt(data.loaded / data.total * 100, 10);
      var percentage = progress.toString() + '%';
      data.progressBar.find('.progress-bar').css('width', percentage).html(percentage);

    },
    done: function(e, data) {
      console.log('done', data);
      data.progressBar.remove();

      var image = {
        id: data.formData.key.match(/cache\/(.+)/)[1], // have to remove the prefix
        storage: 'cache',
        metadata: {
          size: data.files[0].size,
          filename: data.files[0].name.match(/[^\/\\]+$/)[0], // IE, return full path
          mime_type: data.files[0].type
        }
      };

      var form = $(this).closest('form');
      var form_data = new FormData(form[0]);
      form_data.append($(this).attr('name'), JSON.stringify(image));

      $.ajax(form.attr('action'), {
        contentType: false,
        processData: false,
        data: form_data,
        method: form.attr('method'),
        dataType: 'script'
      });

    }
  });

  // Product Images Upload
  $('#product_image_image').fileupload({
    add: function(e, data) {
      console.log('add', data);
      data.progressBar = $('<div class="progress" style="width:300px"><div class="progress-bar"></div></div>').insertAfter('.form-file-group');
      var options = {
        extensions: data.files[0].name.match(/(\.\w+)?$/)[0], // set the file extension
        _: Date.now()  // prevent caching
      }

      $.getJSON('/productimages/upload/cache/presign', options, function(result) {
        console.log('presign', result);
        data.formData = result.fields;
        data.url = result.url;
        data.paramName = 'file';
        data.submit();
      });
    },
    progress: function(e, data) {
      console.log('progress', data);

      var progress = parseInt(data.loaded / data.total * 100, 10);
      var percentage = progress.toString() + '%';
      data.progressBar.find('.progress-bar').css('width', percentage).html(percentage);

    },
    done: function(e, data) {
      console.log('done', data);
      data.progressBar.remove();

      var image = {
        id: data.formData.key.match(/cache\/(.+)/)[1], // have to remove the prefix
        storage: 'cache',
        metadata: {
          size: data.files[0].size,
          filename: data.files[0].name.match(/[^\/\\]+$/)[0], // IE, return full path
          mime_type: data.files[0].type
        }
      };

      // var form = $(this).closest('form');
      // var form_data = new FormData(form[0]);
      // form_data.append($(this).attr('name'), JSON.stringify(image));

      var params = {
        product_image: {image: JSON.stringify(image)}
      }

      $.ajax('/product_images', {method: 'POST', data: params})
        .done(function(result) {
          var $img = $("<img/>", {src: result.image_url, width: 400});
          var $div = $("<div/>").append($img);
          $(".form-title").append($div);
        });


      // $.ajax(form.attr('action'), {
      //   contentType: false,
      //   processData: false,
      //   data: form_data,
      //   method: form.attr('method'),
      //   dataType: 'json',
      //   success: function(response) {
      //     var $img = $("<img/>", {src: response.image_url, width: 400});
      //     var $div = $("<div/>").append($img);
      //     $(".form-title").append($div);
      //   }
      // });

    }
  });

});