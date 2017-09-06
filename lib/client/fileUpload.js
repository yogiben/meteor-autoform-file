import { $ }           from 'meteor/jquery';
import { Meteor }      from 'meteor/meteor';
import { AutoForm }    from 'meteor/aldeed:autoform';
import { Template }    from 'meteor/templating';
import { ReactiveVar } from 'meteor/reactive-var';
import { Mongo }       from 'meteor/mongo';

Template.afFileUpload.onCreated(function () {
  if (!this.data) {
    this.data = {
      atts: {}
    };
  }
  console.log(this.data);
  this.collection      = Mongo.Collection.get
    ? Mongo.Collection.get(this.data.atts.collection).filesCollection
    : Meteor.connection._mongo_livedata_collections[this.data.atts.collection];
  this.uploadTemplate  = this.data.atts.uploadTemplate || null;
  this.previewTemplate = this.data.atts.previewTemplate || null;

  if (!this.collection) {
    throw new Meteor.Error(404, '[meteor-autoform-files] No such collection "' + this.data.atts.collection + '"');
  }

  this.collectionName = () => {
    return this.data.atts.collection;
  };

  this.currentUpload  = new ReactiveVar(false);
  this.inputName      = this.data.name;
  this.fileId         = new ReactiveVar(this.data.value || false);
  this.formId         = this.data.atts.id;
  return;
});

Template.afFileUpload.helpers({
  previewTemplate() {
    return Template.instance().previewTemplate;
  },
  uploadTemplate() {
    return Template.instance().uploadTemplate;
  },
  currentUpload() {
    return Template.instance().currentUpload.get();
  },
  fileId() {
    return Template.instance().fileId.get() || this.value;
  },
  uploadedFile() {
    var collectionName = Template.instance().collectionName();
    var collection = Mongo.Collection.get
      ? Mongo.Collection.get(collectionName).filesCollection
      : global[collectionName];
    if (!collectionName || !collection) return null;

    var _id = Template.instance().fileId.get() || this.value;
    if (typeof _id !== 'string' || _id.length === 0) return null;
    return collection.findOne({_id:_id});
  }
});

Template.afFileUpload.events({
  'click [data-reset-file]'(e, template) {
    e.preventDefault();
    template.fileId.set(false);
    return false;
  },
  'click [data-remove-file]'(e, template) {
    e.preventDefault();
    template.fileId.set(false);
    try {
      this.remove();
    } catch (error) {
      // we're good here
    }
    return false;
  },
  'change [data-files-collection-upload]'(e, template) {
    if (e.currentTarget.files && e.currentTarget.files[0]) {

      var collectionName = template.collectionName();
      var collection = Mongo.Collection.get
        ? Mongo.Collection.get(collectionName)
        : global[template.collectionName()];

      var upload = collection.filesCollection.insert({
        file: e.currentTarget.files[0],
        streams: 'dynamic',
        chunkSize: 'dynamic'
      }, false);

      const ctx = AutoForm.getValidationContext(template.formId);

      upload.on('start', function () {
        ctx.reset();
        template.currentUpload.set(this);
        return;
      });

      upload.on('error', function (error) {
        ctx.reset();
        ctx.addValidationErrors([{name: template.inputName, type: 'uploadError', value: error.reason}]);
        $(e.currentTarget).val('');
        return;
      });

      upload.on('end', function (error, fileObj) {
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
