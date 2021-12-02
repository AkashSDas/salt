import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/recipe/recipe.dart';
import 'package:salt/providers/recipes_infinite_scroll.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/screens/recipe_update_editor.dart';
import 'package:salt/screens/recipe_view.dart';
import 'package:salt/services/blog_post.dart';
import 'package:salt/services/recipe.dart';
import 'package:salt/utils/index.dart';
import 'package:salt/widgets/alerts/index.dart';
import 'package:salt/widgets/buttons/index.dart';
import 'package:shimmer/shimmer.dart';

/// This widget is meant to be used inside another listview
/// which will get (from backend) more posts when user reaches the
/// end of that listview

class UserRecipesListView extends StatelessWidget {
  const UserRecipesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<RecipesInfiniteScrollProvider>(
      context,
    );

    if (_provider.firstLoading) return const _Loader();
    if (_provider.firstError) {
      return Center(
        child: Text(
          _provider.firstApiResponseMsg,
          style: DesignSystem.bodyIntro,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: _provider.recipes.length,
      itemBuilder: (context, idx) {
        if (idx == _provider.recipes.length - 1) {
          return _Card(recipe: _provider.recipes[idx]);
        }

        return Column(
          children: [
            _Card(recipe: _provider.recipes[idx]),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, idx) {
          if (idx == 2) return _buildEffect(context, idx);

          return Column(
            children: [
              _buildEffect(context, idx),
              const SizedBox(height: 16),
            ],
          );
        });
  }

  Widget _buildEffect(BuildContext context, int idx) {
    return Shimmer.fromColors(
      key: Key(idx.toString()),
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      baseColor: DesignSystem.gallery,
      highlightColor: DesignSystem.alabaster,
    );
  }
}

class _Card extends StatefulWidget {
  final Recipe recipe;
  const _Card({required this.recipe, Key? key}) : super(key: key);

  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
  var loading = false;

  void _gotoView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeViewScreen(recipe: widget.recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider _user = Provider.of<UserProvider>(context);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: DesignSystem.boxShadow1,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _gotoView(context),
          child: Container(
            padding: const EdgeInsets.all(12),

            /// Wrap Column widget with Flexible widget to avoid overflow of
            /// text in Text widget inside the Column widget. This is Flexible
            /// widget is needed in order to avoid text overflow
            child: Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CardCoverImg(imgURL: widget.recipe.coverImgURL),
                  const SizedBox(height: 12),
                  _CardTitle(title: widget.recipe.title),
                  const SizedBox(height: 12),
                  _CardMetadata(recipe: widget.recipe),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: RoundedCornerIconButton(
                            icon: const AspectRatio(
                              aspectRatio: 1,
                              child: FlareActor(
                                'assets/flare-icons/camera.flr',
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                                animation: 'idle',
                              ),
                            ),
                            text: 'Update',
                            onPressed: () {
                              if (!loading) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return RecipeUpdateEditorScreen(
                                        recipe: widget.recipe,
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RoundedCornerIconButton(
                            icon: loading
                                ? const SizedBox(
                                    width: 24,
                                    child: CircularProgressIndicator(),
                                  )
                                : const AspectRatio(
                                    aspectRatio: 1,
                                    child: FlareActor(
                                      'assets/flare-icons/delete.flr',
                                      alignment: Alignment.center,
                                      fit: BoxFit.contain,
                                      animation: 'idle',
                                    ),
                                  ),
                            text: loading ? 'Deleting...' : 'Delete',
                            onPressed: () async {
                              if (!loading) {
                                RecipeService _service = RecipeService();

                                setState(() {
                                  loading = !loading;
                                });

                                /// Delete recipe
                                await _service.deleteRecipe(
                                  widget.recipe.id,
                                  _user.user!.id,
                                  _user.token.toString(),
                                );

                                setState(() {
                                  loading = !loading;
                                });

                                if (_service.error) {
                                  failedSnackBar(
                                    context: context,
                                    msg: _service.msg,
                                  );
                                } else {
                                  /// TODO: remove the card after successful deletion
                                  successSnackBar(
                                    context: context,
                                    msg: _service.msg,
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardCoverImg extends StatelessWidget {
  final String imgURL;
  const _CardCoverImg({required this.imgURL, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: DesignSystem.gallery,
        image: DecorationImage(image: NetworkImage(imgURL), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  final String title;
  const _CardTitle({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: DesignSystem.heading4.copyWith(fontSize: 20),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _CardMetadata extends StatelessWidget {
  final Recipe recipe;
  const _CardMetadata({required this.recipe, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAuthorProfilePic(),
        const SizedBox(width: 16),
        _buildPostInfo(),
      ],
    );
  }

  Widget _buildAuthorProfilePic() {
    return Container(
      height: 38,
      width: 38,
      decoration: BoxDecoration(
        color: DesignSystem.gallery,
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(recipe.author.profilePicURL),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPostInfo() {
    var dt = recipe.updatedAt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recipe.author.username,
          style: DesignSystem.bodyMain.copyWith(
            fontWeight: FontWeight.w700,
            color: DesignSystem.tundora,
            height: 1,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${dt.day} ${monthNames[dt.month]}, ${dt.year} - ${recipe.readTime} min read',
          style: DesignSystem.caption.copyWith(height: 1),
        ),
      ],
    );
  }
}
