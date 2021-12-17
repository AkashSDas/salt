import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salt/models/tag/tag.dart';
import 'package:salt/services/tag.dart';

class PostEditorProvider extends ChangeNotifier {
  var title = '';
  var description = '';
  var content = '';
  var published = false;

  /// only single img will be stored in this list
  List<XFile> coverImg = [];

  /// tags selected by user
  List<Tag> selectedTags = [];

  /// tags selected that are not selected by user (retrieved from backend)
  List<Tag> tags = [];

  /// Loading state when the tags are fetched from the backend
  var tagLoading = false;

  /// Loading state for updating, creating or others...
  var loading = false;

  /// Preview content
  var preview = false;

  // SETTERS

  void setTitle(String value) {
    title = value;
    notifyListeners();
  }

  void setDescription(String value) {
    description = value;
    notifyListeners();
  }

  void setContent(String value) {
    content = value;
    notifyListeners();
  }

  void setPreview(bool value) {
    preview = value;
    notifyListeners();
  }

  void setTagLoading(bool value) {
    tagLoading = value;
    notifyListeners();
  }

  void setPublished(bool value) {
    published = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void setCoverImg(XFile file) {
    coverImg = [file];
    notifyListeners();
  }

  void setTags(List<Tag> value) {
    tags = value;
    notifyListeners();
  }

  void setSelectedTags(List<Tag> value) {
    selectedTags = value;
    notifyListeners();
  }

  // TAGS

  /// Add tag
  void addTag(Tag t) {
    tags = [...tags, t];
    notifyListeners();
  }

  /// Remove tag
  void removeTag(String id) {
    tags = tags.where((t) => t.id != id).toList();
    notifyListeners();
  }

  /// Add selected tag
  void addSelectedTag(Tag t) {
    selectedTags = [...selectedTags, t];
    notifyListeners();
  }

  /// Remove selected tag
  void removeSelectedTag(String id) {
    selectedTags = selectedTags.where((t) => t.id != id).toList();
    notifyListeners();
  }

  List<String> getSelectsTagsIds() {
    return selectedTags.map((t) => t.id.toString()).toList();
  }

  // FETCH FUNCTIONS

  /// Get tags
  Future<void> getAllTags() async {
    final service = TagService();
    setTagLoading(true);
    final response = await service.getTags();
    if (!response.error || response.data != null) {
      List<Tag> ts = [];
      for (int i = 0; i < response.data['tags'].length; i++) {
        ts.add(Tag.fromJson(response.data['tags'][i]));
      }
      setTags(ts);
    }
    setTagLoading(false);
  }

  /// For updating post, filter out tags are already in post
  Future<void> getAllTagsFiltered() async {
    final service = TagService();
    setTagLoading(true);
    final response = await service.getTags();
    if (!response.error || response.data != null) {
      List<Tag> filteredTags = [];
      List<Tag> ts = response.data['tags'].map((t) => Tag.fromJson(t)).toList();
      for (final t in ts) {
        final exists = tags.where((tag) => t.id == tag.id).isNotEmpty;
        if (!exists) filteredTags.add(t);
      }
      setTags(filteredTags);
    }
    setTagLoading(false);
  }

  // CONSTRUCTORS

  /// For creating post
  PostEditorProvider();

  /// For updating post
  PostEditorProvider.fromPost({
    required this.title,
    required this.description,
    required this.content,
    required this.tags,
    required this.published,
  });
}
