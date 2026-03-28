import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/quiz_provider.dart';
import '../models/quiz_result.dart';
import '../models/career.dart';
import '../data/onet_data.dart';
import '../theme/app_colors.dart';
import 'careers_screen.dart';
import 'quiz_screen.dart';

// ─────────────────────────────────────────────
// Career-specific roadmaps
// ─────────────────────────────────────────────
class _RoadmapStep {
  final String phase;
  final String title;
  final String description;
  final String timeframe;
  final IconData icon;
  final Color color;

  const _RoadmapStep({
    required this.phase,
    required this.title,
    required this.description,
    required this.timeframe,
    required this.icon,
    required this.color,
  });
}

Map<String, List<_RoadmapStep>> _careerRoadmaps = {
  'soft-dev': [
    _RoadmapStep(phase: '1', title: 'Choose Science Stream', description: 'Take Physics, Chemistry & Maths in Class 11-12. Focus on Informatics Practices / CS if available.', timeframe: 'Class 11–12', icon: Icons.school_rounded, color: AppColors.mint),
    _RoadmapStep(phase: '2', title: 'Clear JEE / Board Exams', description: 'Target JEE Main/Advanced for IITs and NITs. Score 80%+ in boards as backup for private colleges.', timeframe: 'Class 12 Board Year', icon: Icons.assignment_rounded, color: AppColors.coral),
    _RoadmapStep(phase: '3', title: 'B.Tech CS/IT Degree', description: 'Enroll in a B.Tech program. Join college coding clubs, hackathons, and start open-source contributions.', timeframe: 'Years 1–4', icon: Icons.laptop_mac_rounded, color: AppColors.lavender),
    _RoadmapStep(phase: '4', title: 'Build Projects & Portfolio', description: 'Build 3–5 real-world projects (web, mobile, AI). Maintain a GitHub portfolio that recruiters can see.', timeframe: 'Years 2–4', icon: Icons.code_rounded, color: AppColors.accent),
    _RoadmapStep(phase: '5', title: 'Internships & Placements', description: 'Do 1–2 internships at startups/MNCs. Crack campus placements or apply directly to top product companies.', timeframe: 'Final Year', icon: Icons.work_rounded, color: AppColors.mint),
    _RoadmapStep(phase: '6', title: 'Specialize & Grow', description: 'Pick a specialization (AI/ML, Cloud, DevOps, Full-stack). Target FAANG-level companies or build a startup.', timeframe: '1–3 Years Post-Job', icon: Icons.trending_up_rounded, color: AppColors.coral),
  ],
  'doctor': [
    _RoadmapStep(phase: '1', title: 'Science with Biology', description: 'Choose Physics, Chemistry & Biology (PCB) in Class 11-12. Start NEET preparation from Class 11.', timeframe: 'Class 11–12', icon: Icons.school_rounded, color: AppColors.mint),
    _RoadmapStep(phase: '2', title: 'Crack NEET-UG', description: 'Score 600+ in NEET-UG for a government MBBS seat. Aim for AIIMS/JIPMER for top institutes.', timeframe: 'Class 12', icon: Icons.assignment_rounded, color: AppColors.coral),
    _RoadmapStep(phase: '3', title: 'MBBS (5.5 Years)', description: 'Complete MBBS including 1-year internship rotating across departments. Build clinical skills.', timeframe: 'Years 1–5.5', icon: Icons.local_hospital_rounded, color: AppColors.lavender),
    _RoadmapStep(phase: '4', title: 'NEET-PG & Specialization', description: 'Write NEET-PG for MD/MS. Choose your specialization (Surgery, Cardiology, Paediatrics etc).', timeframe: '1 Year Post MBBS', icon: Icons.favorite_rounded, color: AppColors.accent),
    _RoadmapStep(phase: '5', title: 'Residency & Practice', description: 'Complete your post-graduate residency. Build a network, open your clinic or join a hospital.', timeframe: '3 Years', icon: Icons.work_rounded, color: AppColors.mint),
  ],
  'data-sci': [
    _RoadmapStep(phase: '1', title: 'Science / Maths Stream', description: 'Take Physics, Chemistry & Maths. Excel in statistics and informatics. Learn Python basics in Class 12.', timeframe: 'Class 11–12', icon: Icons.school_rounded, color: AppColors.mint),
    _RoadmapStep(phase: '2', title: 'B.Sc Statistics / B.Tech', description: 'Enroll in Statistics, CS, or Applied Mathematics. Join data science clubs and Kaggle competitions.', timeframe: 'Years 1–3/4', icon: Icons.bar_chart_rounded, color: AppColors.coral),
    _RoadmapStep(phase: '3', title: 'Learn Core Data Skills', description: 'Master Python, pandas, SQL, and machine learning (scikit-learn, TensorFlow). Complete online certifications.', timeframe: 'Years 1–3', icon: Icons.code_rounded, color: AppColors.lavender),
    _RoadmapStep(phase: '4', title: 'Real Projects & Kaggle', description: 'Participate in Kaggle competitions. Build end-to-end ML projects. Publish findings on GitHub.', timeframe: 'Years 2–4', icon: Icons.insights_rounded, color: AppColors.accent),
    _RoadmapStep(phase: '5', title: 'M.Sc / MBA Analytics (Optional)', description: 'Pursue M.Sc Data Science from IITs/IISc or an MBA with Analytics focus for leadership roles.', timeframe: 'Years 5–7', icon: Icons.school_rounded, color: AppColors.mint),
    _RoadmapStep(phase: '6', title: 'Industry Role & Specialize', description: 'Land a Data Analyst → Data Scientist role. Specialize in NLP, Computer Vision, or Recommendation Systems.', timeframe: 'Year 4+', icon: Icons.trending_up_rounded, color: AppColors.coral),
  ],
  'ca': [
    _RoadmapStep(phase: '1', title: 'Commerce Stream', description: 'Take Accountancy, Business Studies & Economics in Class 11-12. Score 90%+ in boards.', timeframe: 'Class 11–12', icon: Icons.school_rounded, color: AppColors.mint),
    _RoadmapStep(phase: '2', title: 'CA Foundation Exam', description: 'Register with ICAI and clear the CA Foundation exam after Class 12 boards.', timeframe: 'Immediately After Class 12', icon: Icons.assignment_rounded, color: AppColors.coral),
    _RoadmapStep(phase: '3', title: 'CA Intermediate (IPCC)', description: 'Clear Group 1 & 2 of the CA Intermediate exam. Start 3-year articleship training with a firm.', timeframe: 'Years 1–3', icon: Icons.menu_book_rounded, color: AppColors.lavender),
    _RoadmapStep(phase: '4', title: 'CA Final Exams', description: 'Attempt CA Final exams during or after articleship. Clear both groups to become a qualified CA.', timeframe: 'Years 3–5', icon: Icons.emoji_events_rounded, color: AppColors.accent),
    _RoadmapStep(phase: '5', title: 'Join a Big-4 or Practice', description: 'Join Deloitte, PwC, EY or KPMG. Or open your own CA firm. Get industry certifications (CFA, CPA) to grow further.', timeframe: 'Year 5+', icon: Icons.work_rounded, color: AppColors.mint),
  ],
  'default': [
    _RoadmapStep(phase: '1', title: 'Choose the Right Stream', description: 'Select the stream (Science/Commerce/Arts) that aligns with your career. Focus on relevant subjects in Class 11-12.', timeframe: 'Class 11–12', icon: Icons.school_rounded, color: AppColors.mint),
    _RoadmapStep(phase: '2', title: 'Prepare & Clear Entrance Exams', description: 'Identify key entrance exams for your chosen career. Prepare systematically and aim for top colleges.', timeframe: 'Class 12', icon: Icons.assignment_rounded, color: AppColors.coral),
    _RoadmapStep(phase: '3', title: 'Undergraduate Degree', description: 'Pursue the recommended undergraduate program. Actively participate in co-curriculars and build practical skills.', timeframe: 'Years 1–4', icon: Icons.laptop_mac_rounded, color: AppColors.lavender),
    _RoadmapStep(phase: '4', title: 'Gain Practical Experience', description: 'Do internships and projects related to your career goal. Build a portfolio that showcases your skills.', timeframe: 'Years 2–4', icon: Icons.handshake_rounded, color: AppColors.accent),
    _RoadmapStep(phase: '5', title: 'Launch Your Career', description: 'Land your first full-time role. Focus on continuous learning, networking, and skill development.', timeframe: 'Final Year Onwards', icon: Icons.trending_up_rounded, color: AppColors.mint),
  ],
};

List<_RoadmapStep> _getRoadmap(String careerCode) =>
    _careerRoadmaps[careerCode] ?? _careerRoadmaps['default']!;

// ─────────────────────────────────────────────
// Stream details (subjects + colleges)
// ─────────────────────────────────────────────
class _StreamDetail {
  final String stream;
  final String emoji;
  final String tagline;
  final List<String> subjects;
  final List<String> topColleges;
  final List<String> exitOptions;
  final Color color;
  final Color lightColor;

  const _StreamDetail({
    required this.stream,
    required this.emoji,
    required this.tagline,
    required this.subjects,
    required this.topColleges,
    required this.exitOptions,
    required this.color,
    required this.lightColor,
  });
}

final Map<String, _StreamDetail> _streamDetails = {
  'Science': _StreamDetail(
    stream: 'Science',
    emoji: '🔬',
    tagline: 'The path of innovation and discovery',
    subjects: ['Physics', 'Chemistry', 'Maths/Biology', 'Informatics Practices', 'English'],
    topColleges: ['IITs (JEE Advanced)', 'AIIMS (NEET)', 'BITS Pilani', 'NITs (JEE Main)', 'IISc Bangalore'],
    exitOptions: ['Engineering', 'Medicine', 'Research', 'Data Science', 'Architecture', 'Pilot'],
    color: Color(0xFF4ECDC4),
    lightColor: Color(0xFFE0F7F5),
  ),
  'Commerce': _StreamDetail(
    stream: 'Commerce',
    emoji: '📊',
    tagline: 'The path of business and entrepreneurship',
    subjects: ['Accountancy', 'Business Studies', 'Economics', 'Maths (Optional)', 'English'],
    topColleges: ['SRCC Delhi', 'IIMs (MBA)', 'NLSIU (Law)', 'Loyola Chennai', 'NMIMS Mumbai'],
    exitOptions: ['CA / CFA', 'MBA', 'Entrepreneur', 'Investment Banking', 'Marketing', 'HR'],
    color: Color(0xFFFFB627),
    lightColor: Color(0xFFFFF8E1),
  ),
  'Arts': _StreamDetail(
    stream: 'Arts / Humanities',
    emoji: '🎨',
    tagline: 'The path of creativity and human connection',
    subjects: ['History', 'Political Science', 'Psychology', 'Sociology', 'English Literature'],
    topColleges: ['IIMC Delhi (Journalism)', 'NID Ahmedabad (Design)', 'TISS (Social Work)', 'NLU (Law)', 'DU Colleges'],
    exitOptions: ['Journalism', 'Law', 'Psychology', 'Design', 'Teaching', 'Civil Services'],
    color: Color(0xFF9B5DE5),
    lightColor: Color(0xFFF3E8FF),
  ),
  'Science or Vocational': _StreamDetail(
    stream: 'Science / Vocational',
    emoji: '🛠️',
    tagline: 'The path of practical skills and innovation',
    subjects: ['Physics', 'Maths', 'Workshop / Vocational Trades', 'Computer Hardware', 'English'],
    topColleges: ['IITs (B.Tech)', 'Polytechnic Colleges', 'ITI Institutes', 'NTI Gondia (Pilot)', 'CEPT Ahmedabad'],
    exitOptions: ['Engineering', 'Pilot', 'Civil Engineer', 'Aerospace', 'Automotive Tech', 'Robotics'],
    color: Color(0xFFFF6B6B),
    lightColor: Color(0xFFFFEBEB),
  ),
  'Arts or Commerce': _StreamDetail(
    stream: 'Arts or Commerce',
    emoji: '🤝',
    tagline: 'The path of service and social impact',
    subjects: ['Sociology', 'Psychology', 'Political Science', 'Economics', 'English'],
    topColleges: ['TISS Mumbai', 'JNU Delhi', 'LSR Delhi', 'Jamia Millia Islamia', 'BHU'],
    exitOptions: ['Social Work', 'Teaching', 'HR', 'Counseling', 'NGO Management', 'Civil Services'],
    color: Color(0xFFFF8E3C),
    lightColor: Color(0xFFFFF3E0),
  ),
  'Arts or Design': _StreamDetail(
    stream: 'Arts / Design',
    emoji: '🎭',
    tagline: 'The path where imagination meets impact',
    subjects: ['Fine Arts', 'Design', 'Psychology', 'Computer Applications', 'English Literature'],
    topColleges: ['NID Ahmedabad', 'IIT Bombay IDC', 'Pearl Academy', 'Srishti Manipal', 'NIFT'],
    exitOptions: ['UX Design', 'Graphic Design', 'Animation', 'Film Making', 'Architecture', 'Music'],
    color: Color(0xFF9B5DE5),
    lightColor: Color(0xFFF3E8FF),
  ),
};

_StreamDetail _getStreamDetail(String stream) =>
    _streamDetails[stream] ?? _streamDetails['Science']!;

// ─────────────────────────────────────────────
// Main Screen
// ─────────────────────────────────────────────
class AnalysisReportScreen extends StatefulWidget {
  const AnalysisReportScreen({super.key});

  @override
  State<AnalysisReportScreen> createState() => _AnalysisReportScreenState();
}

class _AnalysisReportScreenState extends State<AnalysisReportScreen> {
  final PageController _tabController = PageController();
  int _activeTab = 0;

  static const List<Map<String, dynamic>> _tabs = [
    {'label': 'Analysis', 'icon': Icons.analytics_rounded},
    {'label': 'Career', 'icon': Icons.work_rounded},
    {'label': 'Roadmap', 'icon': Icons.map_rounded},
    {'label': 'Stream', 'icon': Icons.school_rounded},
  ];

  void _switchTab(int index) {
    setState(() => _activeTab = index);
    _tabController.animateToPage(index,
        duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    final result = provider.getResult();
    final careers = provider.getMatchedCareers(result);
    final topCareer = careers.isNotEmpty ? careers.first : null;
    final stream = provider.getRecommendedStream(result);
    final streamDetail = _getStreamDetail(stream);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: Column(
        children: [
          _buildHeader(context, provider, result, topCareer),
          _buildTabBar(),
          Expanded(
            child: PageView(
              controller: _tabController,
              onPageChanged: (i) => setState(() => _activeTab = i),
              children: [
                _buildAnalysisTab(result),
                _buildCareerTab(careers, result),
                _buildRoadmapTab(topCareer),
                _buildStreamTab(streamDetail),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildShareFAB(provider, result, topCareer, stream),
    );
  }

  // ── Header ────────────────────────────────────
  Widget _buildHeader(BuildContext context, QuizProvider provider,
      QuizResult result, Career? topCareer) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.meshGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back + title row
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Detailed Analysis Report',
                      style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Holland Code & name row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Holland code badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: AppColors.accent.withOpacity(0.4)),
                    ),
                    child: Text(
                      result.hollandCode,
                      style: GoogleFonts.dmSans(
                        color: AppColors.accent,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                      ),
                    ),
                  ).animate().scale(
                      duration: 700.ms, curve: Curves.elasticOut),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (provider.userName.isNotEmpty)
                          Text(
                            provider.userName,
                            style: GoogleFonts.dmSans(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        Text(
                          'Your Holland Code',
                          style: GoogleFonts.dmSans(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),
                        if (topCareer != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: AppColors.accent, size: 14),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Best match: ${topCareer.title}',
                                  style: GoogleFonts.dmSans(
                                    color: AppColors.accent,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.05, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  // ── Tab Bar ─────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final isActive = _activeTab == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => _switchTab(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF1A1A2E)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _tabs[i]['icon'] as IconData,
                      size: 18,
                      color: isActive ? AppColors.accent : const Color(0xFF9AA5B1),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _tabs[i]['label'] as String,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive
                            ? Colors.white
                            : const Color(0xFF9AA5B1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ══════════════════════════════════════════════
  // TAB 1 — Analysis
  // ══════════════════════════════════════════════
  Widget _buildAnalysisTab(QuizResult result) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        _sectionTitle('🧬 Personality Breakdown'),
        const SizedBox(height: 12),
        // Score bars for all 6 RIASEC types
        ...ONETData.riasecTypes.map((type) {
          final pct = result.percentageScores[type.code] ?? 0.0;
          final isTop = result.topPersonalityTypes.contains(type.code);
          return _ScoreBar(
            type: type,
            percentage: pct,
            isTop: isTop,
          );
        }),
        const SizedBox(height: 24),
        _sectionTitle('🏅 Your Dominant Traits'),
        const SizedBox(height: 12),
        ...result.topPersonalityTypes.take(3).map((code) {
          final type = ONETData.riasecTypes
              .firstWhere((t) => t.code == code, orElse: () => ONETData.riasecTypes[0]);
          return _PersonalityCard(type: type).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
        }),
        if (result.careerGuidance != null) ...[
          const SizedBox(height: 24),
          _sectionTitle('🤖 AI Career Guidance'),
          const SizedBox(height: 12),
          _AIGuidanceCard(guidance: result.careerGuidance!),
        ],
        const SizedBox(height: 90),
      ],
    );
  }

  // ══════════════════════════════════════════════
  // TAB 2 — Career
  // ══════════════════════════════════════════════
  Widget _buildCareerTab(List<Career> careers, QuizResult result) {
    final top3 = careers.take(3).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        _sectionTitle('🏆 Top Career Matches'),
        const SizedBox(height: 4),
        Text(
          'Ranked by how well they align with your personality',
          style: GoogleFonts.dmSans(
              fontSize: 13, color: const Color(0xFF667788)),
        ),
        const SizedBox(height: 16),
        ...List.generate(top3.length, (i) {
          final career = top3[i];
          final matchScore =
              career.calculateMatchScore(result.percentageScores);
          return _CareerMatchCard(
            career: career,
            matchScore: matchScore,
            rank: i + 1,
          ).animate().fadeIn(delay: (i * 150).ms).slideY(begin: 0.1);
        }),
        const SizedBox(height: 16),
        // All careers by stream
        _sectionTitle('📚 All Careers by Stream'),
        const SizedBox(height: 12),
        ...['Science', 'Commerce', 'Arts'].map((streamName) {
          final streamCareers = careers
              .where((c) => c.stream == streamName)
              .take(4)
              .toList();
          if (streamCareers.isEmpty) return const SizedBox.shrink();
          return _StreamGroupCard(
              streamName: streamName, careers: streamCareers, result: result);
        }),
        const SizedBox(height: 90),
      ],
    );
  }

  // ══════════════════════════════════════════════
  // TAB 3 — Roadmap
  // ══════════════════════════════════════════════
  Widget _buildRoadmapTab(Career? topCareer) {
    final roadmap = _getRoadmap(topCareer?.code ?? 'default');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        _sectionTitle('🗺️ Your Career Path Plan'),
        const SizedBox(height: 4),
        Text(
          'How to become a ${topCareer?.title ?? "Career Professional"} — step by step',
          style: GoogleFonts.dmSans(
              fontSize: 13, color: const Color(0xFF667788)),
        ),
        const SizedBox(height: 20),
        // Target career card
        if (topCareer != null)
          _TargetCareerBanner(career: topCareer)
              .animate()
              .fadeIn(delay: 100.ms)
              .scale(begin: const Offset(0.97, 0.97)),
        const SizedBox(height: 24),
        // Vertical timeline
        ...List.generate(roadmap.length, (i) {
          final step = roadmap[i];
          final isLast = i == roadmap.length - 1;
          return _RoadmapStepTile(
            step: step,
            isLast: isLast,
            index: i,
          );
        }),
        const SizedBox(height: 90),
      ],
    );
  }

  // ══════════════════════════════════════════════
  // TAB 4 — Stream
  // ══════════════════════════════════════════════
  Widget _buildStreamTab(_StreamDetail detail) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        _sectionTitle('🎓 Recommended Stream'),
        const SizedBox(height: 12),

        // Stream hero card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                detail.color.withOpacity(0.85),
                detail.color.withOpacity(0.55),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(detail.emoji, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(
                detail.stream,
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                detail.tagline,
                style: GoogleFonts.dmSans(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.97, 0.97)),

        const SizedBox(height: 20),
        _sectionTitle('📖 Core Subjects'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: detail.subjects.map((s) => _SubjectChip(subject: s, color: detail.color)).toList(),
        ),

        const SizedBox(height: 20),
        _sectionTitle('🏛️ Top Colleges / Exams'),
        const SizedBox(height: 10),
        ...detail.topColleges.asMap().entries.map((e) {
          return _CollegeRow(
            index: e.key + 1,
            name: e.value,
            color: detail.color,
          ).animate().fadeIn(delay: (e.key * 80).ms).slideX(begin: 0.05);
        }),

        const SizedBox(height: 20),
        _sectionTitle('🚀 Career Opportunities'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: detail.exitOptions
              .map((o) => _ExitOptionChip(option: o, color: detail.color))
              .toList(),
        ),

        const SizedBox(height: 20),
        // Action button
        SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CareersScreen()),
              );
            },
            icon: const Icon(Icons.explore_rounded),
            label: Text(
              'Explore All Careers',
              style: GoogleFonts.dmSans(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1A2E),
              foregroundColor: Colors.white,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () {
              final p =
                  Provider.of<QuizProvider>(context, listen: false);
              p.resetQuiz();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const QuizScreen()),
                (r) => false,
              );
            },
            icon: const Icon(Icons.refresh_rounded),
            label: Text(
              'Retake Quiz',
              style: GoogleFonts.dmSans(
                  fontSize: 15, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1A1A2E),
              side: BorderSide(
                  color: const Color(0xFF1A1A2E).withOpacity(0.3)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
            ),
          ),
        ),
        const SizedBox(height: 90),
      ],
    );
  }

  // ── Share FAB ─────────────────────────────────
  Widget _buildShareFAB(QuizProvider provider, QuizResult result,
      Career? topCareer, String stream) {
    return FloatingActionButton.extended(
      onPressed: () {
        final name =
            provider.userName.isNotEmpty ? provider.userName : 'I';
        Share.share(
          '🚀 $name just completed the FutureNext Career Quiz!\n\n'
          '🧬 Holland Code: ${result.hollandCode}\n'
          '🏆 Best Career: ${topCareer?.title ?? "N/A"}\n'
          '🎓 Recommended Stream: $stream\n\n'
          'Find your ideal career path at FutureNext!',
        );
      },
      backgroundColor: const Color(0xFF1A1A2E),
      icon: const Icon(Icons.share_rounded, color: AppColors.accent),
      label: Text(
        'Share Report',
        style: GoogleFonts.dmSans(
            color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ).animate().scale(delay: 500.ms, curve: Curves.bounceOut);
  }

  // Section title helper
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF1A1A2E),
      ),
    );
  }
}

// ──────────────────────────────────────────────────
// REUSABLE WIDGETS
// ──────────────────────────────────────────────────

class _ScoreBar extends StatelessWidget {
  final dynamic type; // RIASECType
  final double percentage;
  final bool isTop;

  const _ScoreBar({
    required this.type,
    required this.percentage,
    required this.isTop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isTop
            ? Border.all(color: type.color.withOpacity(0.4), width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          Text(type.emoji,
              style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          type.name,
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        if (isTop) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: type.color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'TOP',
                              style: GoogleFonts.dmSans(
                                color: type.color,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: type.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: const Color(0xFFEEF0F5),
                    valueColor: AlwaysStoppedAnimation<Color>(type.color),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.05, end: 0);
  }
}

class _PersonalityCard extends StatelessWidget {
  final dynamic type;
  const _PersonalityCard({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (type.color as Color).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (type.color as Color).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(type.emoji,
                    style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${type.name} (${type.code})',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    Text(
                      type.tagline,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: type.color as Color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            type.description,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: const Color(0xFF445566),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: (type.traits as List<String>).map((t) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: (type.color as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  t,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: type.color as Color,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Text(
            '💡 Inspired by: ${(type.famousExamples as List<String>).join(', ')}',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: const Color(0xFF667788),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _AIGuidanceCard extends StatelessWidget {
  final String guidance;
  const _AIGuidanceCard({required this.guidance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.04),
            AppColors.accent.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded,
                  color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                'AI Personalized Insight',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            guidance,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              height: 1.6,
              color: const Color(0xFF445566),
            ),
          ),
        ],
      ),
    );
  }
}

class _CareerMatchCard extends StatelessWidget {
  final Career career;
  final double matchScore;
  final int rank;

  const _CareerMatchCard({
    required this.career,
    required this.matchScore,
    required this.rank,
  });

  Color get _rankColor {
    if (rank == 1) return const Color(0xFFFFB627);
    if (rank == 2) return const Color(0xFF90A4AE);
    return const Color(0xFFFF8E3C);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: rank == 1
            ? Border.all(color: const Color(0xFFFFB627).withOpacity(0.5), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Rank badge
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _rankColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '#$rank',
                    style: GoogleFonts.dmSans(
                      color: _rankColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(career.emoji,
                  style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      career.title,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    Text(
                      '${career.stream} · ${career.salary}',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: const Color(0xFF667788),
                      ),
                    ),
                  ],
                ),
              ),
              // Match % badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _matchColor(matchScore).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${matchScore.toStringAsFixed(0)}%',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: _matchColor(matchScore),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Match bar
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: matchScore / 100,
              backgroundColor: const Color(0xFFEEF0F5),
              valueColor:
                  AlwaysStoppedAnimation<Color>(_matchColor(matchScore)),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            career.description,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: const Color(0xFF445566),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.trending_up_rounded,
                  size: 14, color: Color(0xFF4ECDC4)),
              const SizedBox(width: 4),
              Text(
                'Growth: ${career.growth}',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4ECDC4),
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.school_rounded,
                  size: 14, color: Color(0xFF667788)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  career.education,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: const Color(0xFF667788),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (career.brightOutlook) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.bolt_rounded,
                    size: 14, color: AppColors.accent),
                const SizedBox(width: 4),
                Text(
                  'Bright Outlook — High demand in coming years',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _matchColor(double score) {
    if (score >= 70) return const Color(0xFF4ECDC4);
    if (score >= 45) return const Color(0xFFFFB627);
    return const Color(0xFFFF6B6B);
  }
}

class _StreamGroupCard extends StatelessWidget {
  final String streamName;
  final List<Career> careers;
  final QuizResult result;

  const _StreamGroupCard({
    required this.streamName,
    required this.careers,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            streamName,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 10),
          ...careers.map((c) {
            final score = c.calculateMatchScore(result.percentageScores);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Text(c.emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      c.title,
                      style: GoogleFonts.dmSans(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    '${score.toStringAsFixed(0)}% match',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: const Color(0xFF4ECDC4),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _TargetCareerBanner extends StatelessWidget {
  final Career career;
  const _TargetCareerBanner({required this.career});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF2D2D4E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Text(career.emoji,
              style: const TextStyle(fontSize: 44)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Goal 🎯',
                  style: GoogleFonts.dmSans(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  career.title,
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '${career.stream} · ${career.salary}',
                  style: GoogleFonts.dmSans(
                    color: Colors.white60,
                    fontSize: 13,
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

class _RoadmapStepTile extends StatelessWidget {
  final _RoadmapStep step;
  final bool isLast;
  final int index;

  const _RoadmapStepTile({
    required this.step,
    required this.isLast,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column (phase number + line)
          SizedBox(
            width: 44,
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: step.color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      step.phase,
                      style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: step.color.withOpacity(0.25),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Right content
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border:
                    Border.all(color: step.color.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(step.icon, color: step.color, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          step.title,
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: step.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      step.timeframe,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: step.color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    step.description,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: const Color(0xFF445566),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
          .animate()
          .fadeIn(delay: (index * 120).ms)
          .slideX(begin: 0.05, end: 0),
    );
  }
}

class _SubjectChip extends StatelessWidget {
  final String subject;
  final Color color;
  const _SubjectChip({required this.subject, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        subject,
        style: GoogleFonts.dmSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _CollegeRow extends StatelessWidget {
  final int index;
  final String name;
  final Color color;
  const _CollegeRow(
      {required this.index, required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$index',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            name,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExitOptionChip extends StatelessWidget {
  final String option;
  final Color color;
  const _ExitOptionChip({required this.option, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04), blurRadius: 6),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_forward_ios_rounded, size: 10, color: color),
          const SizedBox(width: 5),
          Text(
            option,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }
}
