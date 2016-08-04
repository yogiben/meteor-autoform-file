Template.afFileUpload.onCreated(function () {
  this.collection = Meteor.connection._mongo_livedata_collections[this.data.atts.collection]
  if (!this.collection) {
    throw new Meteor.Error(404, '[meteor-autoform-files] No such collection "' + this.data.atts.collection + '"');
  }
  this.collectionName = () => this.data.atts.collection
  this.currentUpload  = new ReactiveVar(false);
  this.fileId         = new ReactiveVar(this.data.value);
  this.error          = new ReactiveVar(false);
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
    return global[Template.instance().collectionName()].findOne({
      _id: Template.instance().fileId.get()
    });
  },
  error() {
    return Template.instance().error.get();
  }
});

Template.afFileUpload.events({
  'click [data-remove-file]'(e, template) {
    template.fileId.set(false);
    try {
      this.remove();
    } catch (e) {}
    return;
  },
  'change [data-files-collection-upload]'(e, template) {
    if (e.currentTarget.files && e.currentTarget.files[0]) {
      const input  = $(e.currentTarget);
      const parent = input.parent('.form-group');
      parent.removeClass('has-error');
      const upload = global[template.collectionName()].insert({
        file: e.currentTarget.files[0],
        streams: 'dynamic',
        chunkSize: 'dynamic'
      }, false);

      upload.on('start', function () {
        template.currentUpload.set(this);
        return;
      });

      upload.on('error', function (error) {
        template.error.set(error.reason);
        input.val('');
        if (parent[0]) {
          parent.addClass('has-error');
        }
        return;
      });

      upload.on('end', (error, fileObj) => {
        if (!error) {
          if (template) {
            template.fileId.set(fileObj._id);
          }
        }
        template.currentUpload.set(false);
        return;
      });

      upload.start();
    }
  }
});