document.addEventListener("DOMContentLoaded", function() {
  document
    .querySelectorAll('.embedded-content-desmos-file')
    .forEach(loadDesmosCalculator);
});

function loadDesmosCalculator(elmt) {
  var state          = elmt.dataset['state'],
      calculatorElmt = elmt.getElementsByClassName('desmos-calculator')[0],
      calculator     = Desmos.GraphingCalculator(calculatorElmt);
  calculator.setState(state);
};
