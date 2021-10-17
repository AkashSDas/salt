import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/providers/blog-post-editor.dart';

class BlogPostEditorFoodCategoriesTags extends StatefulWidget {
  const BlogPostEditorFoodCategoriesTags({Key? key}) : super(key: key);

  @override
  State<BlogPostEditorFoodCategoriesTags> createState() =>
      _BlogPostEditorFoodCategoriesTagsState();
}

class _BlogPostEditorFoodCategoriesTagsState
    extends State<BlogPostEditorFoodCategoriesTags>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    BlogPostEditorFormProvider _provider =
        Provider.of<BlogPostEditorFormProvider>(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        _provider.tags.length,
        (index) => Container(
          height: 44,
          padding: EdgeInsets.only(top: 6, bottom: 6, left: 8, right: 8),
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
                child: Center(child: Text(_provider.tags[index].emoji)),
              ),
              SizedBox(width: 8),
              Text(
                '${_provider.tags[index].name[0].toUpperCase()}${_provider.tags[index].name.substring(1)}',
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  _provider.addFoodCategory(_provider.tags[index]);
                  _provider.removeTag(_provider.tags[index].id);
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
    );
  }
}
