// Function that refreshes the validations of a selected form's input field
// It adds error messages and changes the input's container colors
// Parameters: containerSelector   selector of the container of the input;
//             containerChildNum   number of children in that container (without error messages);
//             inputType           type of input;
//             errorMessage        error message of the input, or it's input denomination if there are no errors;
function refreshInputValidations(containerSelector, containerChildNum, inputType, errorMessage) {
  var inputContainer = document.querySelector(containerSelector);
  var inputField = document.querySelector(`${containerSelector} ${inputType}`);

  // If it exists, remove any input related error message
  removeValidations(containerSelector, containerChildNum, inputType)

  // Get the error message that's passed when there are no erros
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

// Function that removes any input related error messages and validation marks
function removeValidations(containerSelector, containerChildNum, inputType) {
  var inputContainer = document.querySelector(containerSelector);
  var inputField = document.querySelector(`${containerSelector} ${inputType}`);

  // If they exist, remove the error messages
  if (inputContainer.childElementCount > containerChildNum) {
    document.querySelector(`${containerSelector} .invalid-feedback`).remove();
  }

  // Remove the validation marks
  inputContainer.classList.remove('form-group-valid', 'form-group-invalid');
  inputField.classList.remove('is-valid', 'is-invalid');
}

export { refreshInputValidations };
export { removeValidations };
