function autoCompleteCocktail() {
  const searchField = document.getElementById('search-input');    // Search field element

  searchField.addEventListener('input', (event) => {
    const param = event.target.value.trim();                      // Search param striped of trailing whitespaces
    const coktaislNames = gon.cocktails_names.split(' -/- ');     // Array of Cocktails to search into

    for (let i = 0; i < coktaislNames.length; i++) {
      // Iterate over the array of Cocktails and get the elements that include the search param
      if (coktaislNames[i].toUpperCase().includes(param.toUpperCase())) {
        console.log(coktaislNames[i]);
      }
    }
  });
}

export { autoCompleteCocktail };
