import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/models/food-category/food-category.dart';
import 'package:salt/providers/food-categories.dart';
import 'package:salt/services/food-categories.dart';
import 'package:salt/widgets/blog-post-editor/description-input.dart';
import 'package:salt/widgets/blog-post-editor/food-categories-dropdown.dart';
import 'package:salt/widgets/blog-post-editor/title-input.dart';

class BlogPostEditor extends StatefulWidget {
  BlogPostEditor({Key? key}) : super(key: key);

  @override
  _BlogPostEditorState createState() => _BlogPostEditorState();
}

class _BlogPostEditorState extends State<BlogPostEditor> {
  Map<String, String> _formData = {'title': '', 'description': ''};
  List<dynamic> _categories = []; // List<FoodCategory>
  FoodCategory _foodCategoryState = FoodCategory(
    id: 'default',
    emoji: '',
    name: 'Select tags',
    description: 'Default dropdown value',
  );

  List<FoodCategory> _tags = [];

  bool categoriesLoading = false;

  @override
  void initState() {
    super.initState();
    _getFoodCategories();
  }

  Future<void> _getFoodCategories() async {
    setState(() {
      categoriesLoading = true;
    });
    var response = await getAllFoodCategories();
    if (response[1] == null) {
      /// No error
      setState(() {
        _categories = response[0]['data']['categories'];
        categoriesLoading = false;
      });
    }
  }

  final _titleValidator = MultiValidator([
    RequiredValidator(errorText: 'Title is required'),
    MinLengthValidator(
      6,
      errorText: 'Title should be atleast 6 characters long',
    ),
  ]);

  final _descriptionValidator = MultiValidator([
    RequiredValidator(errorText: 'Description is required'),
    MinLengthValidator(
      6,
      errorText: 'Description should be atleast 6 characters long',
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              TitleFormInput(
                name: 'title',
                label: 'Title',
                hintText: 'Cool foodo',
                formData: _formData,
                validator: _titleValidator,
              ),
              SizedBox(height: 16),
              DescriptionFormInput(
                name: 'description',
                label: 'Description',
                hintText: 'This is how we do it',
                formData: _formData,
                validator: _descriptionValidator,
              ),
              SizedBox(height: 16),
              _buildFoodCategoryDropDown(),
              SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  _tags.length,
                  (index) => Container(
                    height: 44,
                    padding:
                        EdgeInsets.only(top: 6, bottom: 6, left: 8, right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffBDBDBD), width: 0.5),
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.15),
                              ),
                            ],
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Center(child: Text(_tags[index].emoji)),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${_tags[index].name[0].toUpperCase()}${_tags[index].name.substring(1)}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _categories = [..._categories, _tags[index]];
                              _tags = _tags
                                  .where((tag) => tag.id != _tags[index].id)
                                  .toList();
                            });
                          },
                          child: Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: DesignSystem.grey2,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.cancel,
                                color: DesignSystem.grey3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodCategoryDropDown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: DesignSystem.grey3, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: DropdownButton<String>(
        underline: SizedBox(),
        isExpanded: true,
        icon: !categoriesLoading
            ? Icon(Icons.arrow_drop_down)
            : Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
        elevation: 4,
        value:
            _foodCategoryState.id == 'default' ? null : _foodCategoryState.id,
        hint: Text('Select tags'),
        items: <FoodCategory>[..._categories].map((FoodCategory value) {
          return DropdownMenuItem<String>(
            key: Key(value.id),
            value: value.id,
            child: Text(
              '${value.emoji} ${value.name[0].toUpperCase()}${value.name.substring(1)}',
            ),
          );
        }).toList(),
        onChanged: (_id) {
          if (_id != null) {
            var selectedCategory =
                _categories.where((element) => element.id == _id).toList();

            if (selectedCategory.length > 0) {
              setState(() {
                _tags = [..._tags, selectedCategory[0]];
                _categories = _categories
                    .where((element) => element.id != selectedCategory[0].id)
                    .toList();
              });
            }
          }
        },
      ),
    );
  }
}
