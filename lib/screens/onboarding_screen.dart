import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../providers/quiz_provider.dart';
import 'quiz_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _slides = [
    OnboardingData(
      title: 'What Do You Love\nDoing?',
      description: "We'll ask you 30 fun questions about activities you enjoy. No right or wrong answers!",
      emoji: '🧭',
      bgColor: const Color(0xFFEBF0FF),
      circleBgColor: const Color(0xFFD0DBFF),
    ),
    OnboardingData(
      title: 'Discover Your\nPersonality Type',
      description: 'Find out if you are a Builder, Thinker, Creator, Helper, Leader, or Organizer.',
      emoji: '🎯',
      bgColor: const Color(0xFFE2F7F5),
      circleBgColor: const Color(0xFFC1EFEC),
    ),
    OnboardingData(
      title: 'Get Your Perfect\nCareer Matches',
      description: 'See careers that match YOUR personality — with salary, growth, and what subjects to study.',
      emoji: '🚀',
      bgColor: const Color(0xFFFFF0EE),
      circleBgColor: const Color(0xFFFFD9D5),
    ),
    OnboardingData(
      title: 'Tell Us About You',
      description: 'Customize your report with your name and current class.',
      emoji: '👤',
      bgColor: const Color(0xFFF0EBFF),
      circleBgColor: const Color(0xFFDDD0FF),
      isProfile: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        color: _slides[_currentPage].bgColor,
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _currentPage < 3
                    ? TextButton(
                        onPressed: () => _controller.jumpToPage(3),
                        child: Text(
                          'Skip',
                          style: GoogleFonts.dmSans(
                            color: const Color(0xFF8899AA),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : const SizedBox(height: 44),
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    if (slide.isProfile) {
                      return _buildProfileSlide();
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Illustrated Icon
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: slide.circleBgColor,
                            ),
                            child: Center(
                              child: Text(
                                slide.emoji,
                                style: const TextStyle(fontSize: 100),
                              ),
                            ),
                          )
                          .animate(key: ValueKey(index))
                          .scale(duration: 700.ms, curve: Curves.elasticOut),

                          const SizedBox(height: 56),

                          Text(
                            slide.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF1A1A2E),
                              height: 1.1,
                            ),
                          )
                          .animate(key: ValueKey('t$index'))
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: 0.2, end: 0, duration: 500.ms),

                          const SizedBox(height: 20),

                          Text(
                            slide.description,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(
                              color: const Color(0xFF667788),
                              fontSize: 17,
                              height: 1.5,
                            ),
                          )
                          .animate(key: ValueKey('d$index'))
                          .fadeIn(duration: 500.ms, delay: 150.ms),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: _controller,
                      count: _slides.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: const Color(0xFF1A1A2E),
                        dotColor: const Color(0xFF1A1A2E).withOpacity(0.15),
                        dotHeight: 8,
                        dotWidth: 8,
                        expansionFactor: 4,
                        spacing: 6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage < 3) {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutCubic,
                            );
                          } else {
                            final name = _nameController.text.trim();
                            if (name.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter your name')),
                              );
                              return;
                            }
                            final provider = context.read<QuizProvider>();
                            provider.setUserProfile(name, _selectedGrade);
                            provider.startDynamicQuiz();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const QuizScreen()),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1A2E),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentPage == 3 ? "Let's Begin!" : 'Next',
                              style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (_currentPage == 3) ...[
                              const SizedBox(width: 10),
                              const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final TextEditingController _nameController = TextEditingController();
  String _selectedGrade = 'Class 10';
  final List<String> _grades = ['Class 8', 'Class 9', 'Class 10', 'Class 11', 'Class 12'];

  Widget _buildProfileSlide() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFDDD0FF),
            ),
            child: const Center(
              child: Text('👤', style: TextStyle(fontSize: 70)),
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 40),
          Text(
            'Tell Us About You',
            style: GoogleFonts.dmSans(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 32),
          
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Test user',
                hintStyle: GoogleFonts.dmSans(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.person_rounded, color: Color(0xFF8899AA)),
                contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              ),
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
          
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedGrade,
                isExpanded: true,
                style: GoogleFonts.dmSans(color: const Color(0xFF1A1A2E), fontSize: 16),
                items: _grades.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (val) => setState(() => _selectedGrade = val!),
              ),
            ),
          ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String emoji;
  final Color bgColor;
  final Color circleBgColor;
  final bool isProfile;

  OnboardingData({
    required this.title,
    required this.description,
    required this.emoji,
    required this.bgColor,
    required this.circleBgColor,
    this.isProfile = false,
  });
}
