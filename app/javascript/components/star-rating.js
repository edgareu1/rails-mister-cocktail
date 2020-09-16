// Function that quantifies each review's rating with stars
function starRating() {
  var listRatings = document.querySelectorAll('p[data-rating]');  // List of reviews headers

  // For each review headers...
  for (let i = 0; i < listRatings.length; i++) {
    let elementRating = parseInt(listRatings[i].getAttribute('data-rating'));   // It's rating

    // Add (rating num minus 5) empty stars
    for (let n = 0; n < (5 - elementRating); n++) {
      let starEmpty = document.createElement('i');
      starEmpty.classList = 'far fa-star';
      listRatings[i].prepend(starEmpty);
    }

    // Add (rating num) filled stars
    for (let n = 0; n < elementRating; n++) {
      let starFill = document.createElement('i');
      starFill.classList = 'fas fa-star';
      listRatings[i].prepend(starFill);
    }
  }
}

export { starRating };
