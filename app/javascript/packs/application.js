// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

import 'bootstrap';

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import { autoCompleteCocktail } from '../components/auto-complete-cocktail';
import { readMore } from '../components/read-more';
import { smoothPagination } from '../components/smooth-pagination';
import { smoothScrolling } from '../components/smooth-scrolling';

document.addEventListener('turbolinks:load', () => {
  const anchor = document.getElementById('scroller');

  if (anchor) {
    autoCompleteCocktail();
    smoothPagination();
    smoothScrolling(anchor, '#container-cards', 600);
  } else {
    readMore();
  }
});
