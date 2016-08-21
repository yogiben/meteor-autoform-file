AutoForm.addInputType("fileUpload", {
  template: "afFileUpload"
});

AutoForm._globalHooks.onSuccess.push(function (type) {
  if (type === 'insert') {
    this.template.$('[data-reset-file]').click();
  }
});

SimpleSchema.messages({
  uploadError: '[value]'
});
