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
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              OnboardingPage(
                image: 'assets/images/page1.png',
                title: 'Manage your tasks',
                description:
                    'You can easily manage all of your daily tasks in DoMe for free',
                currentPage: _currentPage,
                index: 0,
              ),
              OnboardingPage(
                image: 'assets/images/page2.png',
                title: 'Create daily routine',
                description:
                    'In Uptodo  you can create your personalized routine to stay productive',
                currentPage: _currentPage,
                index: 1,
              ),
              OnboardingPage(
                image: 'assets/images/page3.png',
                title: 'Orgonaize your tasks',
                description:
                    'You can organize your daily tasks by adding your tasks into separate categories',
                currentPage: _currentPage,
                index: 2,
              ),
            ],
          ),
          Positioned(
            top: 40,
            left: 20,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StartScreen()),
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
                  onPressed: _currentPage > 0
                      ? () {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
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
                  onPressed: () {
                    if (_currentPage < 2) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StartScreen()),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: tdDarkPurple,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      )),
                  child: Text(
                    _currentPage == 2 ? 'GET STARTED' : 'NEXT',
                    style: TextStyle(
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
    );
  }
}


