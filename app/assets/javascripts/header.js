$(document).on('turbolinks:load', function() {

  $categoryNav = $("[data-behavior='category-nav']");
  $categoryNavLink = $("[data-behavior='category-nav-link']");

  $categoryNavLink.on('click', handleClick);

  function handleClick() {
    $categoryNav.toggleClass('is-open');
  }

});