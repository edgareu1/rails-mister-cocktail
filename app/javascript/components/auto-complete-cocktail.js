function autoCompleteCocktail() {
  const searchField = document.getElementById('search-input');    // Search field element

  searchField.addEventListener('input', (event) => {
    const param = event.target.value.trim();                      // Search param striped of trailing whitespaces
    const coktaislNames = gon.cocktails_names.split(' -/- ');     // Array of Cocktails to search into

    let autoCompleteList = document.getElementById("autocomplete-list"); // Get the autocomplete list

    // If the autocomplete list does not exist, then create it
    if (!autoCompleteList) {
      autoCompleteList = document.createElement("div");
      autoCompleteList.setAttribute("id", "autocomplete-list");

      let searchFieldContainer = searchField.parentNode;
      searchFieldContainer.appendChild(autoCompleteList);

      // Make sure the position of the autocomplete list is relative to the 'searchField'
      searchFieldContainer.style.position = 'relative';

    // If the autocomplete list already exists, then empty it
    } else {
      emptyList();
    }

    // Iterate over the array of Cocktails
    for (let i = 0; i < coktaislNames.length; i++) {
      // Check if the item matches the search param
      let wordIndex = coktaislNames[i].toUpperCase().indexOf(param.toUpperCase());

      // If it matches then...
      if (wordIndex >= 0) {
        let cocktailElement = document.createElement("div");

        // Make the matching letters bold
        cocktailElement.innerHTML = coktaislNames[i].substr(0, wordIndex);
        cocktailElement.innerHTML += "<strong>" + coktaislNames[i].substr(wordIndex, param.length) + "</strong>";
        cocktailElement.innerHTML += coktaislNames[i].substr(wordIndex + param.length);

        // Insert the matched item into the autocomplete list
        autoCompleteList.appendChild(cocktailElement);

        // If the item is clicked upon, then the 'searchField' is filled with that item's value
        cocktailElement.addEventListener('click', function(e) {
          searchField.value = coktaislNames[i];

          emptyList();
        });
      }
    }
  });

  // Empty the autocomplete list
  function emptyList() {
    let autoCompleteList = document.getElementById("autocomplete-list");
    if (autoCompleteList) autoCompleteList.innerHTML = '';
  }
}

export { autoCompleteCocktail };
