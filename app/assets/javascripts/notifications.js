/////////////////////
//  Notifications  //
/////////////////////

$(document).on('turbolinks:load', function() {

  var $notifications          = $("[data-behavior='notifications']");
  var $notificationsLink      = $("[data-behavior='notifications-link']");
  var $notificationsDropdown  = $("[data-behavior='notifications-dropdown']");
  var $notificationsList      = $("[data-behavior='notifications-list']");
  var $notificationsCount     = $notifications.attr('data-notifications-count');

  $notificationsLink.on('click', handleClick);

  function resetNotification() {
    $("[data-behavior='notifications-counter']").text(0);
    $notificationsList.children('.is-unread').removeClass('is-unread');
    $notifications.removeClass('has-unread');
  }

  function markAsRead() {
    if ($notificationsCount > 0) {
      $.post('/notifications/mark_as_read', function(data) {
        $notifications.attr('data-notifications-count', 0);
      });
    }
  }

  function handleClick(e) {
    if ($notificationsDropdown.is(':hidden')) {

      e.stopPropagation();
      $notificationsDropdown.show();
      markAsRead();

    } else {

      e.stopPropagation();
      $notificationsDropdown.hide();

      if ($notificationsCount > 0) {
        resetNotification();
      }
    }
  }

  window.onclick = function(e) {
    if ($notificationsDropdown.is(':visible')) {

      if (e.target !== $notificationsDropdown) {
        $notificationsDropdown.hide();

        if ($notificationsCount > 0) {
          resetNotification();
        }
      }
    }
  }

});