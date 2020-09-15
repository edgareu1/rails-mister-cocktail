// Function that will hide the text that exceds a certain length, while giving the user the option
// to view it (view more); if this option is selected, the user may also choose 'read less'
function readMore() {
  var showHeight = 42;
  var moretext = '<span class="elipse">...</span>&nbsp;Read more';
  var lesstext = 'Read less';

  var reviewsList = document.getElementsByClassName('read-more');

  for (let i = 0; i < reviewsList.length; i++) {
    var element = reviewsList[i];

    if(element.clientHeight > showHeight) {
      element.style.height = `${showHeight}px`;

      let elementParent = element.parentElement;
      elementParent.style.position = 'relative';
      elementParent.style.marginBottom = '32px';

      let link = document.createElement("a");
      link.innerHTML = moretext;
      link.classList.add('morelink');

      element.parentElement.appendChild(link);
    }
  }
};

export { readMore };
