// Function that creates an autocomplete list for cocktail name suggestions
function autoCompleteCocktail() {
  // Define two variables to follow the number of items in the autocomplete list and the currently selected item
  let ItemIndexCounter, selectedItemIndex;

  // Use the gem 'gon' to call the Cocktails controller variable 'cocktails_names'
  const cocktailNames = gon.cocktail_names.split(' -/- ');
  const searchField = document.getElementById('search-input');    // Search field element

  // Each time the user writes on the 'searchField'...
  searchField.addEventListener('input', (event) => {
    const param = event.target.value.trim();  // Search param

    ItemIndexCounter = -1;    // Autocomplete list is empty
    selectedItemIndex = -1;   // No item is selected

    let autoCompleteList = document.getElementById("autocomplete-list"); // Get the autocomplete list

    // If the autocomplete list doesn't exist, then create it
    if (!autoCompleteList) {
      autoCompleteList = document.createElement("div");
      autoCompleteList.setAttribute("id", "autocomplete-list");

      searchField.parentNode.appendChild(autoCompleteList);

    // If the autocomplete list already exists, then empty it
    } else {
      emptyList();
    }

    // If the search param is empty, then just refresh the Cocktails#index page
    if (param === '') {
      refreshPageSearch(param);
      return;
    }

    // Iterate over the array of cocktails
    for (let i = 0; i < cocktailNames.length; i++) {
      // Check if the item matches the search param (which happens when the index is different from -1)
      let wordIndex = cocktailNames[i].toUpperCase().indexOf(param.toUpperCase());

      // If it matches, then add the cocktail to the autocomplete list
      if (wordIndex >= 0) {
        ItemIndexCounter++;
        if (ItemIndexCounter > 4) break;  // Make sure the maximum number of matches displayed is 5

        let cocktailElement = document.createElement("div");
        cocktailElement.setAttribute('data-index', ItemIndexCounter); // Save the index of the item in a data attribute

        // Make the matching letters bold
        cocktailElement.innerHTML = cocktailNames[i].substr(0, wordIndex);
        cocktailElement.innerHTML += "<strong>" + cocktailNames[i].substr(wordIndex, param.length) + "</strong>";
        cocktailElement.innerHTML += cocktailNames[i].substr(wordIndex + param.length);

        autoCompleteList.appendChild(cocktailElement);  // Insert the matched item in the autocomplete list

        // If the item is clicked upon, then fill the 'searchField' with that item value
        cocktailElement.addEventListener('click', () => {
          searchField.value = cocktailNames[i];

          refreshPageSearch(searchField.value); // Refresh the Cocktails#index page with the clicked item as a search param
          emptyList();
        });

        // When the user hovers the mouse over an item, it gets 'selected'
        cocktailElement.addEventListener("mouseover", () => {
          selectedItemIndex = cocktailElement.getAttribute('data-index');
          removeSelected();
          addSelected();
        });
      }
    }

    refreshPageSearch(param); // Refresh the Cocktails#index page with the search param
  });

  // When the user presses down a key on the 'searchField'...
  searchField.addEventListener("keydown", (event) => {
    // Only advance if the autocomplete list exists and has items
    let autoCompleteList = document.getElementById("autocomplete-list");
    if ((!autoCompleteList) || autoCompleteList.childElementCount == 0) return;

    // If the arrow DOWN key is pressed, then the 'selected' item becomes the one with +1 index value
    if (event.keyCode == 40) {
      selectedItemIndex++;
      removeSelected();
      addSelected();

    // If the arrow UP key is pressed, then the 'selected' item becomes the one with -1 index value
    } else if (event.keyCode == 38) {
      selectedItemIndex--;
      removeSelected();
      addSelected();

    // If the ENTER key is pressed, then prevent the form from being submitted and simulate the click on the
    // 'selected' item
    } else if (event.keyCode == 13) {
      event.preventDefault();

      autoCompleteList = autoCompleteList.getElementsByTagName("div");
      if (selectedItemIndex > -1) autoCompleteList[selectedItemIndex].click();
    }
  });

  // Function that empties the autocomplete list if the event is outside of the 'searchField' and the autocomplete list
  function closeAutoCompleteList(event) {
    if (event.target.id == 'search-input' || event.target.hasAttribute('data-index') || event.target.hasAttribute('data-dismiss')) return;
    emptyList();
  }

  document.addEventListener("click", closeAutoCompleteList);      // Uppon the User clicking in a normal device
  document.addEventListener("touchstart", closeAutoCompleteList); // Upoon the User touching in a mobile device

  // Function that empties the autocomplete list
  function emptyList() {
    let autoCompleteList = document.getElementById("autocomplete-list");
    if (autoCompleteList) autoCompleteList.innerHTML = '';
  }

  // Function that uses jQuery to refresh the Cocktails#index page with a certain search param
  function refreshPageSearch(param) {
    $.getScript(`/cocktails?query=${param}&commit=Search`);
  }

  // Function that removes the 'selected' classification from the previous 'selected' item
  function removeSelected() {
    let selectedElement = document.querySelector('.autocomplete-selected');
    if (selectedElement) selectedElement.classList.remove("autocomplete-selected");
  }

  // Function that marks the new selected item as 'selected'
  function addSelected() {
    let autoCompleteList = document.querySelectorAll('#autocomplete-list div');

    if (selectedItemIndex >= autoCompleteList.length) selectedItemIndex = 0;
    if (selectedItemIndex < 0) selectedItemIndex = (autoCompleteList.length - 1);

    autoCompleteList[selectedItemIndex].classList.add("autocomplete-selected");
  }
}

export { autoCompleteCocktail };
