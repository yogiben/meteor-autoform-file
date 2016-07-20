Template.afFileUpload.onCreated(function () {
  this.collectionName = () => this.data.atts.collection
  this.fileId = new ReactiveVar(this.data.value);
  this.currentUpload = new ReactiveVar(false);
});



Template.afFileUpload.helpers({
  currentUpload: function () {
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
  },
  'change .af-file-upload-capture': function (e, template) {
    if (e.currentTarget.files && e.currentTarget.files[0]) {
      // We upload only one file, in case 
      // multiple files were selected
      var upload = global[template.collectionName()].insert({
        file: e.currentTarget.files[0],
        streams: 'dynamic',
        chunkSize: 'dynamic'
      }, false);

      upload.on('start', function () {
        template.currentUpload.set(this);
      });

      upload.on('end', function (error, fileObj) {
        if (error) {
          //alert('Error during upload: ' + error);
        } else {
          //alert('File "' + fileObj.name + '" successfully uploaded');
          template.fileId.set(fileObj._id);
        }
        template.currentUpload.set(false);
      });

      upload.start();
    }
  }
});