import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/color.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final int currentPage;
  final int index;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.currentPage,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: tdBlack,
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 40), 
          Image.asset(
            image,
            height: 350,
            width: 230,
          ),
          const SizedBox(height: 40), 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (dotIndex) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 20,
                height: 4,
                decoration: BoxDecoration(
                  color: currentPage == dotIndex ? tdWhite : tdGrey,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 50),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: tdWhite,
              fontSize: 32,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 80), 
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: tdWhite,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'Lato',
            ),
          ),
          const Spacer(), 
        ],
      ),
    );
  }
}