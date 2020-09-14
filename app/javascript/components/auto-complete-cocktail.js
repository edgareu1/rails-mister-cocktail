// Create an autocomplete list for the Cocktails search while refreshing the page automatically (using AJAX)
// based on the search parameter
function autoCompleteCocktail() {
  const searchField = document.getElementById('search-input');    // Search field element
  const cocktailsNames = gon.cocktails_names.split(' -/- ');      // Array of Cocktails to search into

  // Define two variables to track: the item's index on the autocomplete list;
  //                                and the currently selected item's index;
  let indexCounter, selectedItemIndex;

  // Each time the user writes on the 'searchField', then...
  searchField.addEventListener('input', (event) => {
    const param = event.target.value.trim();    // Search param striped of trailing whitespaces

    indexCounter = -1;        // The autocomplete list is empty
    selectedItemIndex = -1;   // No item is selected

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

    // If the param is empty, then just refresh the page
    if (param === '') {
      refreshPageSearch(param);
      return;
    };

    // Iterate over the array of Cocktails
    for (let i = 0; i < cocktailsNames.length; i++) {
      // Check if the item matches the search param
      let wordIndex = cocktailsNames[i].toUpperCase().indexOf(param.toUpperCase());

      // If it matches then...
      if (wordIndex >= 0) {
        // Make sure the maximum number of matched items displayed is 5
        indexCounter++;
        if (indexCounter > 4) break;

        let cocktailElement = document.createElement("div");

        // Save the index of the item in a data attribute
        cocktailElement.setAttribute('data-index', indexCounter);

        // Make the matching letters bold
        cocktailElement.innerHTML = cocktailsNames[i].substr(0, wordIndex);
        cocktailElement.innerHTML += "<strong>" + cocktailsNames[i].substr(wordIndex, param.length) + "</strong>";
        cocktailElement.innerHTML += cocktailsNames[i].substr(wordIndex + param.length);

        // Insert the matched item into the autocomplete list
        autoCompleteList.appendChild(cocktailElement);

        // If the item is clicked upon, then the 'searchField' is filled with that item's value
        cocktailElement.addEventListener('click', function() {
          searchField.value = cocktailsNames[i];

          refreshPageSearch(searchField.value); // Refresh the page with the clicked item as a search param
          emptyList();
        });

        // Each time the user hovers it's mouse over an item, it becomes the 'selected' item
        cocktailElement.addEventListener("mouseover", function() {
          selectedItemIndex = cocktailElement.getAttribute('data-index');
          removeSelected();
          addSelected();
        });
      }
    }

    refreshPageSearch(param); // Refresh the page with the search param
  });

  // Each time the user presses down a key on the 'searchField'...
  searchField.addEventListener("keydown", function(e) {
    // Advance only if the autocomplete list exists and has items
    let autoCompleteList = document.getElementById("autocomplete-list");
    if ((!autoCompleteList) || autoCompleteList.childElementCount == 0) return;

    // If the arrow DOWN key is pressed, then the 'selected' item becomes the one with +1 index value
    if (e.keyCode == 40) {
      selectedItemIndex++;
      removeSelected();
      addSelected();

    // If the arrow UP key is pressed, then the 'selected' item becomes the one with -1 index value
    } else if (e.keyCode == 38) {
      selectedItemIndex--;
      removeSelected();
      addSelected();

    // If the ENTER key is pressed, then prevent the form from being submitted and simulate the click on the
    // 'selected' item
    } else if (e.keyCode == 13) {
      e.preventDefault();

      autoCompleteList = autoCompleteList.getElementsByTagName("div");
      if (selectedItemIndex > -1) autoCompleteList[selectedItemIndex].click();
    }
  });

  // If the user clicks outside the 'searchField' or the autocomplete list, then empty the autocomplete list
  // Clicking on the dismiss button of a Modal is the AJAX behaviour to assure all Modals are closed. As such this
  // 'click' event is also ingored
  document.addEventListener("click", function(e) {
    if (e.target.id == 'search-input' || e.target.hasAttribute('data-index') || e.target.hasAttribute('data-dismiss')) {
      return
    };

    emptyList();
  });

  // Empty the autocomplete list
  function emptyList() {
    let autoCompleteList = document.getElementById("autocomplete-list");
    if (autoCompleteList) autoCompleteList.innerHTML = '';
  }

  // Use jQuery to refresh the page based on the search param
  function refreshPageSearch(param) {
    $.getScript(`/cocktails?query=${param}&commit=Search`);
  }

  // Remove the 'selected' classification from the previous 'selected' item
  function removeSelected() {
    let selectedElement = document.getElementsByClassName('autocomplete-selected')[0];
    if (selectedElement) selectedElement.classList.remove("autocomplete-selected");
  }

  // Get the new 'selected' item (which highlights the item)
  function addSelected() {
    let autoCompleteList = document.getElementById("autocomplete-list")
                                   .getElementsByTagName("div");

    if (selectedItemIndex >= autoCompleteList.length) selectedItemIndex = 0;
    if (selectedItemIndex < 0) selectedItemIndex = (autoCompleteList.length - 1);

    autoCompleteList[selectedItemIndex].classList.add("autocomplete-selected");
  }
}

export { autoCompleteCocktail };
