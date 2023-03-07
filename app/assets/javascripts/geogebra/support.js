document.addEventListener("DOMContentLoaded", function() {
  document
    .querySelectorAll('.embedded-content-geogebra-file')
    .forEach(loadGeogebraApplet);
});

function loadGeogebraApplet(elmt) {
  var container  = elmt.getElementsByClassName('ggb-applet-container')[0],
      dataNode   = elmt.getElementsByClassName('ggb-base-64-data')[0],
      parameters = JSON.parse(dataNode.dataset['parameters']),
      applet     = new GGBApplet(parameters, '5.0');
  applet.inject(container.id);
};
