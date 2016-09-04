// Create an immediately invoked functional expression to wrap our code
(function() {

  // Define our constructor
  this.Modal = function() {

    // Create global element references
    this.modal = null;
    this.overlay = null;

    // Determine proper prefix
    this.transitionEnd = transitionSelect();

    // Define option defaults
    var defaults = {
      content: "",
      maxWidth: 600,
      minWidth: 300
    }

    // Create options by extending defaults with the passed in arugments
    if (arguments[0] && typeof arguments[0] === "object") {
      this.options = extendDefaults(defaults, arguments[0]);
    }

  }

  // Public Methods

  Modal.prototype.close = function(e) {
    if (e.target !== this.overlay) return;
    var _ = this;
    this.overlay.className = this.overlay.className.replace(' is-open', '');
    this.overlay.addEventListener(this.transitionEnd, function() {
      _.overlay.parentNode.removeChild(_.overlay);
      document.body.className = document.body.className.replace(' has-modal', '');
    });
  }

  Modal.prototype.open = function() {
    buildOut.call(this);
    initializeEvents.call(this);
    window.getComputedStyle(this.modal).height;
    document.body.className = document.body.className + ' has-modal';
    this.overlay.className = this.overlay.className + ' is-open';
  }

  // Private Methods

  function buildOut() {

    var content, contentHolder, docFrag;

    content = this.options.content;

    // Create a DocumentFragment to build with
    docFrag = document.createDocumentFragment();

    // Create overlay element
    this.overlay = document.createElement("div");
    this.overlay.className = "modal-overlay";
    docFrag.appendChild(this.overlay);

    // Create close button
    this.closeButton = document.createElement("button");
    this.closeButton.className = "modal-close";
    this.closeButton.innerHTML = "×";
    this.overlay.appendChild(this.closeButton);

    // Create modal element
    this.modal = document.createElement("div");
    this.modal.className = "modal"
    this.modal.style.minWidth = this.options.minWidth + "px";
    this.modal.style.maxWidth = this.options.maxWidth + "px";
    this.overlay.appendChild(this.modal);

    // Create content area and append to modal
    contentHolder = document.createElement("div");
    contentHolder.className = "modal-content";
    contentHolder.innerHTML = content;
    this.modal.appendChild(contentHolder);

    // Append DocumentFragment to body
    document.body.appendChild(docFrag);

  }

  function extendDefaults(source, properties) {
    var property;
    for (property in properties) {
      if (properties.hasOwnProperty(property)) {
        source[property] = properties[property];
      }
    }
    return source;
  }

  function initializeEvents() {
    this.overlay.addEventListener('click', this.close.bind(this));
  }

  function transitionSelect() {
    var el = document.createElement("div");
    if (el.style.WebkitTransition) return "webkitTransitionEnd";
    if (el.style.OTransition) return "oTransitionEnd";
    return 'transitionend';
  }

}());