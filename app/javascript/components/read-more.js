// Function that will hide the text that exceds a certain height, while giving the user the option
// to view it ('read more'); if this option is selected, the user can also choose to 'read less'
function readMore() {
  var showHeight = 42;  // Height limit that the review content paragraph can take initially

  // Text that will appear on each link
  var moretext = '<span class="elipse">...</span>&nbsp;Read more';
  var lesstext = 'Read less';

  var reviewsList = document.getElementsByClassName('read-more');   // List of reviews content

  // Iterate over the list
  for (let i = 0; i < reviewsList.length; i++) {
    var element = reviewsList[i];

    // If the element shows more content than permited (his height surpasses the limit), then...
    if(element.clientHeight > showHeight) {
      element.style.height = `${showHeight}px`;   // Change it's height to the height limit

      // Change the parent to accommodate the changes
      let elementParent = element.parentElement;
      elementParent.style.position = 'relative';
      elementParent.style.marginBottom = '32px';

      // Create the link to change the content displayed
      let readLink = document.createElement("a");
      readLink.innerHTML = moretext;
      readLink.classList.add('morelink');

      elementParent.appendChild(readLink);  // Append link to the document

      // Add the toggle behaviour to the link
      readLink.addEventListener('click', (event) => {
        event.preventDefault();   // Prevent the default behaviour of the anchor

        var target = event.target;

        // If the 'read less' link is clicked, then...
        if (target.classList.contains('less')) {
          target.classList.remove('less');
          target.innerHTML = moretext;  // Change the link text

          // Hide the review content that exceds the height limit
          target.previousElementSibling.style.height = `${showHeight}px`;

        // If the 'read more' link is clicked, then...
        } else {
          target.classList.add('less');
          target.innerHTML = lesstext;  // Change the link text

          target.previousElementSibling.style.height = 'fit-content';   // Show the hidden review content
        }
      });
    }
  }
};

export { readMore };
