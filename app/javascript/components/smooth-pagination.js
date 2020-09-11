// Function that makes the pagination links scroll up the beginning of the Cocktails list
function smoothPagination() {
  // Get the Y Coordinate of the Cocktail list
  const scrollCoordY = document.getElementById('container-cards')
                               .offsetTop;

  let anchors = document.getElementsByClassName("page-link"); // Get the links of the pagination

  // For each of the links do...
  for (let anchor of anchors) {
    const anchorRef = anchor.href;

    if (typeof anchorRef !== "undefined") {
      anchor.setAttribute("data-remote", "true"); // Ajaxify the link

      // Upon clicking on the link scroll to the beginning of the Cocktails list
      anchor.addEventListener('click', () => {
        window.scrollTo(0, scrollCoordY);
      });
    }
  }
}

export { smoothPagination };
