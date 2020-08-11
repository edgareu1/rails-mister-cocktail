// Function that will hide the text that exceds a certain length, while giving the user the option
// to view it (view more); if this option is selected, the user may also choose 'read less'
$(document).ready(function readMore() {
  var showChar = 140;
  var ellipsestext = "...";
  var moretext = "Read more";
  var lesstext = "Read less";

  $('.read-more').each(function() {
    var content = $(this).html();

    if(content.length > showChar) {
      var c = content.substr(0, showChar);
      var h = content.substr(showChar, content.length - showChar);

      var html = c
        + '<span class="moreellipses">'
        + ellipsestext
        + '&nbsp;</span><span class="morecontent"><span>'
        + h
        + '</span>&nbsp;<a href="" class="morelink">'
        + moretext
        + '</a></span>';

      $(this).html(html);
    }
  });

  $(".morelink").click(function(){
    if($(this).hasClass("less")) {
      $(this).removeClass("less");
      $(this).html(moretext);
    } else {
      $(this).addClass("less");
      $(this).html(lesstext);
    }

    $(this).parent().prev().toggle();
    $(this).prev().toggle();

    return false;
  });
});
