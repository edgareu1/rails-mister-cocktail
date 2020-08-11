// Method that adds smooth scrolling to the same page links
$(document).ready(function smoothScrolling(){
  $("a").on('click', function(event) {
    // Makes sure this.hash has a value before overriding default behavior
    if (this.hash !== "") {
      // Prevents default anchor click behavior
      event.preventDefault();

      var hash = this.hash;

      // Uses jQuery's animate() method to add smooth page scroll
      // The optional number (800) specifies the number of milliseconds it takes to scroll to the specified area
      $('html, body').animate({
        scrollTop: $(hash).offset().top
      }, 800, function(){
        window.location.hash = hash;
      });
    }
  });
});

// For some reason, exporting more than one JS file is giving a bug...
// As such, this file was directly introduced in Cocktail#Index...