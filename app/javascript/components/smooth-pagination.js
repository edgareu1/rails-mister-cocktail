import { smoothScrolling } from './smooth-scrolling';

// Function that makes the pagination anchors scroll up to the beginning of the Cocktails list
function smoothPagination() {
  const anchors = document.getElementsByClassName("page-link"); // Get the anchors of the pagination

  // For each of the anchors do...
  for (let anchor of anchors) {
    const anchorRef = anchor.href;

    // Make sure the anchor has a page destination
    if (typeof anchorRef !== "undefined") {
      anchor.setAttribute("data-remote", "true"); // Ajaxify the anchor

      // Upon clicking on the anchor, scroll to the beginning of the Cocktails list
      smoothScrolling(anchor, '#container-cards', 250);
    }
  }
}

export { smoothPagination };
