function loadFile(event) {
  let output = document.getElementById("output");
  output.classList.remove("hidden");
  output.src = URL.createObjectURL(event.target.files[0]);
  output.onload = function () {
    URL.revokeObjectURL(output.src); // free memory

    // styles
    let uploadContainer = document.getElementById("upload-container");
    uploadContainer.classList.remove("h-48");
    uploadContainer.classList.add("h-12");
    let uploadContainerBeforeText = document.getElementById(
      "upload-container-before-text"
    );
    uploadContainerBeforeText.classList.add("hidden");
    let uploadContainerAfterText = document.getElementById(
      "upload-container-after-text"
    );
    uploadContainerAfterText.classList.remove("hidden");
    uploadContainerAfterText.classList.add("flex");
    let uploadContainerRemoveButton = document.getElementById(
      "upload-container-remove-button"
    );
    uploadContainerRemoveButton.classList.remove("hidden");
    uploadContainerRemoveButton.classList.add("flex");
  };
}

function resetFile() {
  const fileInput = document.querySelector("#dropzone-file");
  fileInput.value = "";
  let output = document.getElementById("output");
  output.setAttribute("src", "");
  output.classList.add("hidden");
  let uploadContainer = document.getElementById("upload-container");
  uploadContainer.classList.add("h-48");
  uploadContainer.classList.remove("h-12");
  let uploadContainerBeforeText = document.getElementById(
    "upload-container-before-text"
  );
  uploadContainerBeforeText.classList.remove("hidden");
  let uploadContainerAfterText = document.getElementById(
    "upload-container-after-text"
  );
  uploadContainerAfterText.classList.add("hidden");
  uploadContainerAfterText.classList.remove("flex");
  let uploadContainerRemoveButton = document.getElementById(
    "upload-container-remove-button"
  );
  uploadContainerRemoveButton.classList.add("hidden");
  uploadContainerRemoveButton.classList.remove("flex");
}
