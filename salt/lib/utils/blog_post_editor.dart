import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

class BlogPostEditorForm {
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

class CreateBlogPost {
  final String title;
  final String description;
  final String content;
  final List<String> categories;
  final String authorId;
  final XFile coverImg;

  const CreateBlogPost({
    required this.title,
    required this.description,
    required this.content,
    required this.categories,
    required this.authorId,
    required this.coverImg,
  });
}

class UpdateBlogPost {
  final String title;
  final String description;
  final String content;
  final List<String> categories;
  final String authorId;
  final XFile? coverImg;

  const UpdateBlogPost({
    required this.title,
    required this.description,
    required this.content,
    required this.categories,
    required this.authorId,
    this.coverImg,
  });
}
