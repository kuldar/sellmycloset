$(document).keyup(function(event) {
  if (event.keyCode == 27) { 
    $("[data-behavior='modal-overlay']").addClass('is-hidden');
    $("[data-behavior='modal']").html('');
    $("body").removeClass('has-modal');
  }
});

$(document).on('click', "[data-behavior='modal-overlay']", function() {
	$("[data-behavior='modal-overlay']").addClass('is-hidden');
  $("[data-behavior='modal']").html('');
  $("body").removeClass('has-modal');
});

$(document).on('click', "[data-behavior='modal']", function(event) {
  event.stopPropagation();
});