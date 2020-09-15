// Function that will hide the text that exceds a certain length, while giving the user the option
// to view it (view more); if this option is selected, the user may also choose 'read less'
function readMore() {
  var showChar = 140;
  var moretext = '&nbsp;Read more';
  var lesstext = '&nbsp;Read less';

  var reviewsList = document.getElementsByClassName('read-more');

  for (let i = 0; i < reviewsList.length; i++) {
    var element = reviewsList[i];
    var content = element.innerHTML;

    if(content.length > showChar) {
      var c = content.substr(0, showChar);
      var h = content.substr(showChar, content.length - showChar);
      var html = c
        + '<span class="elipse-text">...</span>'
        + '<span class="morecontent">'
        +   '<span class="hidden-content">'
        +     h
        +   '</span>'
        +   '<a href="" class="morelink">'
        +     moretext
        +   '</a>'
        + '</span>';

      element.innerHTML = html;

      element.lastChild.lastChild.addEventListener('click', (event) => {
        event.preventDefault();

        var target = event.target;

        if (target.classList.contains('less')) {
          target.classList.remove('less');
          target.innerHTML = moretext;

          target.previousSibling.style.display = 'none';
          target.parentElement.previousSibling.style.display = 'contents';

        } else {
          target.classList.add('less');
          target.innerHTML = lesstext;

          target.previousSibling.style.display = 'contents';
          target.parentElement.previousSibling.style.display = 'none';
        }
      });
    }
  }
};

export { readMore };
