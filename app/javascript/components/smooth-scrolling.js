// jQuery Function that adds smooth scrolling to the same page links
function smoothScrolling() {
  $('#scroller').on('click', function(event) {
    event.preventDefault(); // Prevents default anchor click behavior

    // Performs the scrolling animation during 800ms
    $("html, body").animate( {
      scrollTop: $('#container-cards').offset().top
    }, 800);
  });
};

export { smoothScrolling };
