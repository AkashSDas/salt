import 'package:flutter/material.dart';
import 'package:salt/design.dart';

class DesignSystemScreen extends StatelessWidget {
  const DesignSystemScreen({Key? key}) : super(key: key);

  Widget _space() => const SizedBox(height: 8);

  Widget _typography() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Heading H1 34 Bold',
          style: TextStyle(
            fontSize: 34,
            fontFamily: DesignSystem.fontHead,
            color: DesignSystem.ebonyClay,
            fontWeight: FontWeight.w700,
          ),
        ),
        _space(),
        const Text(
          'Heading H2 32 Bold',
          style: TextStyle(
            fontSize: 32,
            fontFamily: DesignSystem.fontHead,
            color: DesignSystem.ebonyClay,
            fontWeight: FontWeight.w700,
          ),
        ),
        _space(),
        const Text(
          'Heading H3 28 Bold',
          style: TextStyle(
            fontSize: 28,
            fontFamily: DesignSystem.fontHead,
            color: DesignSystem.ebonyClay,
            fontWeight: FontWeight.w700,
          ),
        ),
        _space(),
        const Text(
          'Heading H4 24 Bold',
          style: TextStyle(
            fontSize: 24,
            fontFamily: DesignSystem.fontHead,
            color: DesignSystem.ebonyClay,
            fontWeight: FontWeight.w700,
          ),
        ),
        _space(),
        const Text(
          'Body Intro Text 20 Medium',
          style: TextStyle(
            fontSize: 20,
            fontFamily: DesignSystem.fontHead,
            color: DesignSystem.mineShaft,
            fontWeight: FontWeight.w500,
            height: 1.4, // 140% or 28px -- 20px * 1.4 == 28px
          ),
        ),
        _space(),
        const Text(
          'Body Main Text 17 Regular',
          style: TextStyle(
            fontSize: 17,
            fontFamily: DesignSystem.fontBody,
            color: DesignSystem.mineShaft,
            fontWeight: FontWeight.w400,
            height: 1.4, // 140% or 28px -- 20px * 1.4 == 28px
          ),
        ),
        _space(),
        const Text(
          'Medium Text 17 Regular',
          style: TextStyle(
            fontSize: 17,
            fontFamily: DesignSystem.fontBody,
            color: DesignSystem.mineShaft,
            fontWeight: FontWeight.w400,
            height: 1.4, // 140% or 28px -- 20px * 1.4 == 28px
          ),
        ),
        _space(),
        const Text(
          'Caption Text 15 Regular',
          style: TextStyle(
            fontSize: 15,
            fontFamily: DesignSystem.fontBody,
            color: DesignSystem.mineShaft,
            fontWeight: FontWeight.w400,
            height: 1.4, // 140% or 28px -- 20px * 1.4 == 28px
          ),
        ),
        _space(),
        const Text(
          'Small Text 13 Regular',
          style: TextStyle(
            fontSize: 13,
            fontFamily: DesignSystem.fontBody,
            color: DesignSystem.mineShaft,
            fontWeight: FontWeight.w400,
            height: 1.4, // 140% or 28px -- 20px * 1.4 == 28px
          ),
        ),
      ],
    );
  }

  Widget _example1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Introduction to Stock Market',
          style: TextStyle(
            fontSize: 34,
            fontFamily: DesignSystem.fontHead,
            color: DesignSystem.ebonyClay,
            fontWeight: FontWeight.w700,
          ),
        ),
        _space(),
        const Text(
          "A stock/equity is a security that represents the ownership of a fraction of a corporation. This entitles the owner of the stock to a proportion of the corporation's assets and profits equal to how much stock they own. Units of stock are called shares.",
          style: TextStyle(
            fontSize: 17,
            fontFamily: DesignSystem.fontBody,
            color: DesignSystem.tundora,
            fontWeight: FontWeight.w400,
            height: 1.4, // 140% or 28px -- 20px * 1.4 == 28px
          ),
        ),
      ],
    );
  }

  Widget _example2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Introduction to Stock Market',
          style: TextStyle(
            fontSize: 32,
            fontFamily: DesignSystem.fontHead,
            color: DesignSystem.ebonyClay,
            fontWeight: FontWeight.w700,
          ),
        ),
        _space(),
        const Text(
          "A stock/equity is a security that represents the ownership of a fraction of a corporation. This entitles the owner of the stock to a proportion of the corporation's assets and profits equal to how much stock they own. Units of stock are called shares.",
          style: TextStyle(
            fontSize: 17,
            fontFamily: DesignSystem.fontBody,
            // color: DesignSystem.tundora,
            color: Color(0xFF7D7D7D),
            fontWeight: FontWeight.w500,
            height: 1.4, // 140% or 28px -- 20px * 1.4 == 28px
          ),
        ),
      ],
    );
  }

  Widget _example3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Introduction to Stock Market',
          style: TextStyle(
            fontSize: 28,
            fontFamily: DesignSystem.fontHead,
            color: DesignSystem.ebonyClay,
            fontWeight: FontWeight.w700,
          ),
        ),
        _space(),
        const Text(
          "A stock/equity is a security that represents the ownership of a fraction of a corporation. This entitles the owner of the stock to a proportion of the corporation's assets and profits equal to how much stock they own. Units of stock are called shares.",
          style: TextStyle(
            fontSize: 17,
            fontFamily: DesignSystem.fontBody,
            color: DesignSystem.mineShaft,
            fontWeight: FontWeight.w400,
            height: 1.4, // 140% or 28px -- 20px * 1.4 == 28px
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16).copyWith(bottom: 64),
        child: ListView(
          clipBehavior: Clip.none,
          children: [
            _typography(),
            const SizedBox(height: 32),
            _example1(),
            const SizedBox(height: 32),
            _example2(),
            const SizedBox(height: 32),
            _example3(),
            const SizedBox(height: 32),
            Column(
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 41),
                        blurRadius: 157,
                        // color: Colors.black.withOpacity(0.07),
                        color: const Color(0xFF767676).withOpacity(0.07),
                      ),
                      BoxShadow(
                        offset: const Offset(0, 8.2),
                        blurRadius: 25.51,
                        // color: Colors.black.withOpacity(0.035),
                        color: const Color(0xFF767676).withOpacity(0.035),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 64),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 16),
                        blurRadius: 32,
                        color: const Color(0xFF767676).withOpacity(0.15),
                      ),
                      BoxShadow(
                        offset: const Offset(0, -8),
                        blurRadius: 16,
                        color: const Color(0xFF767676).withOpacity(0.05),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 64),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 6,
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ],
                  ),
                ),

                /// Experiment
                const SizedBox(height: 64),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 64),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                        color: Colors.black.withOpacity(0.15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 64),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 8),
                        blurRadius: 16,
                        color: const Color(0xFF767676).withOpacity(0.25),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
