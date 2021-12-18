import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

class PostFormValidators {
  final title = MultiValidator([
    RequiredValidator(errorText: 'Title is required'),
    MinLengthValidator(
      6,
      errorText: 'Title should be atleast 6 characters long',
    ),
  ]);

  final description = MultiValidator([
    RequiredValidator(errorText: 'Description is required'),
    MinLengthValidator(
      6,
      errorText: 'Description should be atleast 6 characters long',
    ),
  ]);

  final content = MultiValidator([
    RequiredValidator(errorText: 'Content is required'),
    MinLengthValidator(
      6,
      errorText: 'Content should be atleast 6 characters long',
    ),
  ]);
}

/// Shape of post that's being created
class CreatePost {
  final String title;
  final String description;
  final String content;
  final List<String> tags;
  final XFile coverImg;
  final bool published;

  const CreatePost({
    required this.title,
    required this.description,
    required this.content,
    required this.tags,
    required this.coverImg,
    required this.published,
  });
}

/// Shape of post that's being updated
class UpdatePost {
  final String title;
  final String description;
  final String content;
  final List<String> tags;
  final XFile? coverImg;
  final bool published;
  final String id;

  const UpdatePost({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.tags,
    required this.published,
    this.coverImg,
  });
}
