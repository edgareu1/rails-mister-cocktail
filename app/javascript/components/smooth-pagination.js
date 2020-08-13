// Function that makes the pagination link pages scroll down to the Cocktails list
function smoothPagination() {
  var links = document.getElementsByClassName("page-link")

  // Gets each anchor of the pagination gem
  Array.prototype.forEach.call(links, link => {
    const link_ref = link.href

    // Adds to the current href the anchor of the list
    if (typeof link_ref !== "undefined") {
      link.href = link.href + '#container-cards';
    };
  });
};

export { smoothPagination };
