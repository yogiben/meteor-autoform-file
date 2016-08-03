Template.afFileUpload.onCreated(function () {
  this.collectionName = () => this.data.atts.collection
  this.fileId = new ReactiveVar(this.data.value);
  this.currentUpload = new ReactiveVar(false);
  return;
});

Template.afFileUpload.helpers({
  currentUpload() {
    return Template.instance().currentUpload.get();
  },
  fileId() {
    return Template.instance().fileId.get();
  },
  uploadedFile() {
    let fId = Template.instance().fileId.get();
    let file = global[Template.instance().collectionName()].find({_id: fId});
    return file.cursor;
  }
});

Template.afFileUpload.events({
  'click [data-action="remove-file"]'(e, t) {
    t.fileId.set(false);
    return;
  },
  'change .af-file-upload-capture'(e, template) {
    if (e.currentTarget.files && e.currentTarget.files[0]) {
      const upload = global[template.collectionName()].insert({
        file: e.currentTarget.files[0],
        streams: 'dynamic',
        chunkSize: 'dynamic'
      }, false);

      upload.on('start', function () {
        template.currentUpload.set(this);
        return;
      });

      upload.on('end', (error, fileObj) => {
        if (!error) {
          template.fileId.set(fileObj._id);
        }
        template.currentUpload.set(false);
        return;
      });

      upload.start();
    }
  }
});