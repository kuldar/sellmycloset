$(document).keyup(function(event) {
  if (event.keyCode == 27) { 
    $("[data-behavior='modal-overlay']").addClass('is-hidden');
    $("[data-behavior='modal']").html('');
    $("body").removeClass('has-modal');
  }
});

$(document).on('click tap', "[data-behavior='modal-overlay']", function(event) {
	$("[data-behavior='modal-overlay']").addClass('is-hidden');
  $("[data-behavior='modal']").html('');
  $("body").removeClass('has-modal');
  event.preventDefault();
});

$(document).on('click tap', "[data-behavior='modal']", function(event) {
  event.stopPropagation();
});