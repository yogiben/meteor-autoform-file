AutoForm.addInputType('fileUpload', {
  template: 'afFileUpload'
});

AutoForm._globalHooks.onSuccess.push(function (type) {
  if (type === 'insert') {
    try {
      if (this.template) {
        this.template.$('[data-reset-file]').click();
      }
    } catch (e) {
      // we're good here
    }
  }
});
