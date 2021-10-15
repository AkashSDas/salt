import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/widgets/experiments/blog-post-scroll-event.dart';

class ScrollAnimation extends StatefulWidget {
  const ScrollAnimation({Key? key}) : super(key: key);

  @override
  _ScrollAnimationState createState() => _ScrollAnimationState();
}

class _ScrollAnimationState extends State<ScrollAnimation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        clipBehavior: Clip.none,
        padding: EdgeInsets.all(16),
        child: ChangeNotifierProvider.value(
          value: BlogPostScrollEvent(false),
          child: Builder(
            builder: (context) {
              // Using provider so that this can be used even if
              // the list or item card widgets are extracted
              var _provider = Provider.of<BlogPostScrollEvent>(context);

              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollStartNotification) {
                    // Scroll started
                    _provider.isScrolling = true;
                  } else if (notification is ScrollEndNotification) {
                    // Scroll ended
                    _provider.isScrolling = false;
                  }

                  return true;
                },
                child: ListView.builder(
                  clipBehavior: Clip.none,
                  itemCount: 30,
                  itemBuilder: (context, idx) => TweenAnimationBuilder<double>(
                    // x
                    tween: Tween(
                      begin: _provider.isScrolling ? 0 : 0,
                      end: _provider.isScrolling ? -0.04 : 0,
                    ),
                    duration: Duration(milliseconds: 300),
                    builder: (_, double xRotate, _child) =>
                        TweenAnimationBuilder<double>(
                      // z
                      tween: Tween(
                        begin: _provider.isScrolling ? 0 : 0,
                        end: _provider.isScrolling ? -0.075 : 0,
                      ),
                      duration: Duration(milliseconds: 300),
                      builder: (_, double zRotate, _child) =>
                          TweenAnimationBuilder<double>(
                        // y
                        tween: Tween(
                          begin: _provider.isScrolling ? 0 : 0,
                          end: _provider.isScrolling ? -0.025 : 0,
                        ),
                        duration: Duration(milliseconds: 100),
                        builder: (_, double yRotate, _child) {
                          return Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.01)
                              ..rotateX(xRotate)
                              ..rotateZ(zRotate)
                              ..rotateY(yRotate),
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 32),
                              height: 200,
                              decoration: BoxDecoration(
                                color: DesignSystem.grey3,
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
