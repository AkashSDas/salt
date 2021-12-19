import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';

class TestCardInfo extends StatelessWidget {
  const TestCardInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: DesignSystem.success),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeading(),
          DesignSystem.spaceH20,
          _buildCardNumber(),
          const SizedBox(height: 10),
          _buildCardExpire(),
          const SizedBox(height: 10),
          _buildCardCVV(),
        ],
      ),
    );
  }

  Widget _buildCardCVV() {
    return RichText(
      text: TextSpan(
        text: 'CVV 👉 ',
        style: const TextStyle(
          color: DesignSystem.text1,
          fontSize: 17,
          fontFamily: DesignSystem.fontHighlight,
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(
            text: 'any 3 digit number',
            style: DesignSystem.bodyIntro,
          ),
        ],
      ),
    );
  }

  Widget _buildCardExpire() {
    return RichText(
      text: TextSpan(
        text: 'MM/YY 👉 ',
        style: const TextStyle(
          color: DesignSystem.text1,
          fontSize: 17,
          fontFamily: DesignSystem.fontHighlight,
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(
            text: 'any (in future from now)',
            style: DesignSystem.bodyIntro,
          ),
        ],
      ),
    );
  }

  Widget _buildCardNumber() {
    return RichText(
      text: TextSpan(
        text: 'Card number 👉 ',
        style: const TextStyle(
          color: DesignSystem.text1,
          fontSize: 17,
          fontFamily: DesignSystem.fontHighlight,
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(
            text: '4242424242424242',
            style: DesignSystem.bodyIntro,
          ),
        ],
      ),
    );
  }

  Widget _buildHeading() {
    return const Text(
      'Test card info',
      style: TextStyle(
        color: DesignSystem.success,
        fontSize: 20,
        fontFamily: DesignSystem.fontHighlight,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
