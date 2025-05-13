import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/onboading/widget/onboadingPage.dart';
import 'package:flutter_todo_app/welcome/welcome_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/images/page1.png',
      'title': 'Manage your tasks',
      'description':
          'You can easily manage all of your daily tasks in DoMe for free',
    },
    {
      'image': 'assets/images/page2.png',
      'title': 'Create daily routine',
      'description':
          'In Uptodo you can create your personalized routine to stay productive',
    },
    {
      'image': 'assets/images/page3.png',
      'title': 'Organize your tasks',
      'description':
          'You can organize your daily tasks by adding your tasks into separate categories',
    },
  ];

  void _goToNextPage() {
    if (_currentPage < pages.length - 1) {
      setState(() {
        _currentPage++;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StartScreen()),
      );
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  void _onSwipe(DragEndDetails details) {
    if (details.primaryVelocity == null) return;
    if (details.primaryVelocity! < 0) {
      _goToNextPage();
    } else if (details.primaryVelocity! > 0) {
      _goToPreviousPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = pages[_currentPage];

    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: _onSwipe,
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: OnboardingPage(
                key: ValueKey<int>(_currentPage),
                image: current['image']!,
                title: current['title']!,
                description: current['description']!,
                currentPage: _currentPage,
                index: _currentPage,
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StartScreen()),
                  );
                },
                child: Text(
                  'SKIP',
                  style: TextStyle(
                    color: _currentPage > 0 ? tdWhite : tdGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _currentPage > 0 ? _goToPreviousPage : null,
                    child: Text(
                      'BACK',
                      style: TextStyle(
                        color: _currentPage > 0 ? tdWhite : tdGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _goToNextPage,
                    style: TextButton.styleFrom(
                      backgroundColor: tdDarkPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      _currentPage == pages.length - 1 ? 'GET STARTED' : 'NEXT',
                      style: const TextStyle(
                        color: tdWhite,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
