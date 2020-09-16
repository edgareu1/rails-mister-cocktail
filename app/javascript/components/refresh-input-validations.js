// Function that refreshes the validations of a selected form's input field
// Add error messages and change the input's container colors
// Parameters: containerSelector      selector of the container of a specific input;
//             containerChildNum   number of children in that container (without error messages);
//             errorMessage           error message of that input, or it's input denomination if there are no errors;
function refreshInputValidations(containerSelector, containerChildNum, inputType, errorMessage) {
  var inputContainer = document.querySelector(containerSelector);
  var inputField = document.querySelector(`${containerSelector} ${inputType}`);

  // If it exists, remove any input related error message
  if (inputContainer.childElementCount > containerChildNum) {
    inputContainer.classList.remove('form-group-valid', 'form-group-invalid');
    inputField.classList.remove('is-valid', 'is-invalid');

    document.querySelector(`${containerSelector} .invalid-feedback`).remove();
  }

  // Get the error message that's passed in case there's no erros
  // It's the input denomination capitalized with a trailing whitespace to the right
  const myRegex = /\.[a-z]*_([a-z]*)/;
  var match = myRegex.exec(containerSelector);
  var standardErrorMessage =  match[1].charAt(0).toUpperCase() + match[1].slice(1) + " ";
  
  // If here are input related errors, mark the input as invalid and insert an error message
  if (errorMessage !== standardErrorMessage) {
    inputContainer.classList.add('form-group-invalid');
    inputField.classList.add('is-invalid');

    var Node = document.createElement('div');
    Node.classList = 'invalid-feedback';
    Node.innerHTML = errorMessage;

    inputContainer.appendChild(Node);

  // Otherwise mark the input as valid
  } else {
    inputContainer.classList.add('form-group-valid');
    inputField.classList.add('is-valid');
  }
}

export { refreshInputValidations };
