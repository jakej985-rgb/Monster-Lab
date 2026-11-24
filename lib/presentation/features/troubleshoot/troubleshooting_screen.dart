import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/diagnostic_flow_model.dart';
import '../../shared/widgets/monster_card.dart';

class TroubleshootingScreen extends ConsumerStatefulWidget {
  final String? initialCategory;

  const TroubleshootingScreen({
    super.key,
    this.initialCategory,
  });

  @override
  ConsumerState<TroubleshootingScreen> createState() =>
      _TroubleshootingScreenState();
}

class _TroubleshootingScreenState extends ConsumerState<TroubleshootingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Wizard state
  final List<String> _history = ['root'];
  DiagnosticResult? _currentResult;
  final Set<String> _checkedFixSteps = {};

  // Playbooks state
  DiagnosticCategory? _selectedPlaybookCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onSelectOption(DiagnosticOption option) {
    if (option.result != null) {
      setState(() {
        _currentResult = option.result;
        _checkedFixSteps.clear();
      });
    } else if (option.nextNodeId != null) {
      setState(() {
        _history.add(option.nextNodeId!);
        _currentResult = null;
        _checkedFixSteps.clear();
      });
    }
  }

  void _wizardGoBack() {
    if (_currentResult != null) {
      setState(() {
        _currentResult = null;
        _checkedFixSteps.clear();
      });
    } else if (_history.length > 1) {
      setState(() {
        _history.removeLast();
      });
    }
  }

  void _resetWizard() {
    setState(() {
      _history.clear();
      _history.add('root');
      _currentResult = null;
      _checkedFixSteps.clear();
    });
  }

  Color _getCategoryColor(DiagnosticCategory category) {
    switch (category) {
      case DiagnosticCategory.power:
        return AppColors.energyAmber;
      case DiagnosticCategory.wiring:
        return AppColors.tierBuilder;
      case DiagnosticCategory.compile:
        return AppColors.tierEngineer;
      case DiagnosticCategory.upload:
        return AppColors.primaryViolet;
      case DiagnosticCategory.logic:
        return AppColors.accentCyan;
    }
  }

  String _formatCategory(DiagnosticCategory category) {
    switch (category) {
      case DiagnosticCategory.power:
        return 'POWER & HARDWARE';
      case DiagnosticCategory.wiring:
        return 'BREADBOARD & WIRING';
      case DiagnosticCategory.compile:
        return 'IDE & COMPILE';
      case DiagnosticCategory.upload:
        return 'PORT & UPLOAD';
      case DiagnosticCategory.logic:
        return 'SENSOR & LOGIC';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.healing, color: AppColors.energyAmber),
            SizedBox(width: 8),
            Text('Doctor Monster Clinic',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colorScheme.primary,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          tabs: const [
            Tab(icon: Icon(Icons.psychology), text: 'Diagnostic Wizard'),
            Tab(icon: Icon(Icons.science), text: 'Debugging Method'),
            Tab(icon: Icon(Icons.menu_book), text: 'Failure Playbooks'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWizardTab(),
          _buildMethodTab(),
          _buildPlaybooksTab(),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: DOCTOR MONSTER DIAGNOSTIC WIZARD
  // ==========================================
  Widget _buildWizardTab() {
    if (_currentResult != null) {
      return _buildResultView(_currentResult!);
    }

    final currentNodeId = _history.last;
    final currentNode = DoctorMonsterKnowledgeBase.getNodeById(currentNodeId);

    if (currentNode == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Node not found!'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _resetWizard,
              child: const Text('Restart Wizard'),
            ),
          ],
        ),
      );
    }

    final isRoot = _history.length == 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb / Triage Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _getCategoryColor(currentNode.category)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: _getCategoryColor(currentNode.category),
                      width: 1.2),
                ),
                child: Text(
                  _formatCategory(currentNode.category),
                  style: TextStyle(
                    color: _getCategoryColor(currentNode.category),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              if (!isRoot)
                TextButton.icon(
                  key: const Key('wizard_back_button'),
                  onPressed: _wizardGoBack,
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('Back'),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Question Card
          MonsterCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryViolet.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.help_outline,
                          color: AppColors.primaryViolet, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentNode.title,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currentNode.question,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (currentNode.promptDetails != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryViolet.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currentNode.promptDetails!,
                      style: TextStyle(
                          fontSize: 14,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Select the condition that matches your board:',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Option choices
          ...currentNode.options.map((option) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: MonsterCard(
                onTap: () => _onSelectOption(option),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option.label,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          if (option.description != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              option.description!,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.chevron_right,
                        color: AppColors.primaryViolet),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // Result / Prescription Card
  Widget _buildResultView(DiagnosticResult result) {
    Color bannerColor;
    IconData bannerIcon;
    switch (result.severity) {
      case DiagnosisSeverity.normal:
        bannerColor = AppColors.success;
        bannerIcon = Icons.check_circle_outline;
      case DiagnosisSeverity.caution:
        bannerColor = AppColors.energyAmber;
        bannerIcon = Icons.warning_amber_rounded;
      case DiagnosisSeverity.criticalWarning:
        bannerColor = AppColors.danger;
        bannerIcon = Icons.dangerous_outlined;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Diagnosis Title Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bannerColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: bannerColor, width: 1.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(bannerIcon, color: bannerColor, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DIAGNOSIS FOUND',
                        style: TextStyle(
                          color: bannerColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        result.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: bannerColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Root Cause: ${result.rootCause}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // The Science Explanation
          MonsterCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lightbulb,
                        color: AppColors.energyAmber, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Why this happens (The Science):',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  result.explanation,
                  style: const TextStyle(fontSize: 14, height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Step-by-Step Fix Checklist
          const Text(
            'Prescribed Fix Steps:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...result.fixSteps.asMap().entries.map((entry) {
            final idx = entry.key;
            final stepText = entry.value;
            final isChecked = _checkedFixSteps.contains(stepText);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (isChecked) {
                      _checkedFixSteps.remove(stepText);
                    } else {
                      _checkedFixSteps.add(stepText);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isChecked
                        ? AppColors.success.withValues(alpha: 0.1)
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isChecked
                          ? AppColors.success
                          : Theme.of(context).colorScheme.outlineVariant,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isChecked
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: isChecked
                            ? AppColors.success
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${idx + 1}. $stepText',
                          style: TextStyle(
                            fontSize: 14,
                            decoration:
                                isChecked ? TextDecoration.lineThrough : null,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),

          // Verification Test
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.accentCyan, width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.verified, color: AppColors.accentCyan, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'VERIFICATION TEST',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentCyan,
                        fontSize: 12,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  result.verificationTest,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Wizard Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _wizardGoBack,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Questions'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  key: const Key('reset_wizard_button'),
                  onPressed: _resetWizard,
                  icon: const Icon(Icons.refresh),
                  label: const Text('New Diagnosis'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: AppColors.primaryViolet,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: THE 4-STEP DIAGNOSTIC METHOD
  // ==========================================
  Widget _buildMethodTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryViolet.withValues(alpha: 0.15),
                  AppColors.accentCyan.withValues(alpha: 0.12),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.primaryViolet.withValues(alpha: 0.2)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.military_tech,
                        color: AppColors.primaryViolet, size: 26),
                    SizedBox(width: 10),
                    Text(
                      'The Monster Diagnostic Method',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  'Great engineers do not guess or panic when circuits fail. They apply the 4-step scientific method to isolate the single variable that needs fixing.',
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Step 1
          _buildMethodStepCard(
            stepNumber: 1,
            title: 'OBSERVE WITHOUT GUESSING',
            color: AppColors.tierBuilder,
            icon: Icons.visibility,
            summary:
                'Describe the symptom with exact physical facts instead of assumptions.',
            guidance: [
              'Bad: "My circuit is totally broken and ruined."',
              'Good: "The green ON LED is illuminated, but pin 13 LED never lights up."',
              'Notice sensory clues: Any clicking sound? Any chip getting warm? Any burning smell? Any smoke?',
            ],
          ),
          const SizedBox(height: 14),

          // Step 2
          _buildMethodStepCard(
            stepNumber: 2,
            title: 'ISOLATE THE DOMAIN',
            color: AppColors.energyAmber,
            icon: Icons.category,
            summary:
                'Divide the entire system into 5 independent engineering domains.',
            guidance: [
              'Domain A (Power): Does the board have clean, steady 5V electricity?',
              'Domain B (Wiring): Are jumper wires tight, pins correct, and polarities matched?',
              'Domain C (Compile): Does the sketch compile with 0 orange error messages?',
              'Domain D (Upload): Did avrdude upload binary bytes without serial blocking?',
              'Domain E (Logic): Does code math, threshold comparisons, and timing match the physical environment?',
            ],
          ),
          const SizedBox(height: 14),

          // Step 3
          _buildMethodStepCard(
            stepNumber: 3,
            title: 'TEST ONE HYPOTHESIS AT A TIME',
            color: AppColors.tierEngineer,
            icon: Icons.change_circle_outlined,
            summary:
                'The Golden Engineering Rule: Change only ONE wire or ONE line of code at a time.',
            guidance: [
              'If you move 3 wires and change 2 lines of code all at once, you will never know what actually fixed the problem—or what new bug you created!',
              'Make one small adjustment -> Re-test immediately.',
              'Use the Serial Monitor: print analogRead() or sensor values to see what the microcontroller actually sees.',
            ],
          ),
          const SizedBox(height: 14),

          // Step 4
          _buildMethodStepCard(
            stepNumber: 4,
            title: 'FIX, VERIFY & REFLECT',
            color: AppColors.success,
            icon: Icons.celebration,
            summary:
                'Prove the fix works repeatedly and understand why it happened.',
            guidance: [
              'Test edge cases: does it still work if you cycle power off and on?',
              'Write down what you learned: "I forgot that buzzers are polarized!"',
              'Every hardware glitch you solve permanently upgrades your real engineering skills.',
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildMethodStepCard({
    required int stepNumber,
    required String title,
    required Color color,
    required IconData icon,
    required String summary,
    required List<String> guidance,
  }) {
    return MonsterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$stepNumber',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Icon(icon, color: color, size: 22),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            summary,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: guidance.map((g) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(g,
                            style: const TextStyle(fontSize: 13, height: 1.35)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 3: UNIVERSAL FAILURE PLAYBOOKS
  // ==========================================
  Widget _buildPlaybooksTab() {
    final playbooks = DoctorMonsterKnowledgeBase.failurePlaybooks.where((p) {
      if (_selectedPlaybookCategory == null) return true;
      return p.category == _selectedPlaybookCategory;
    }).toList();

    return Column(
      children: [
        // Category Filter Chips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('All Domains'),
                  selected: _selectedPlaybookCategory == null,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedPlaybookCategory = null;
                      });
                    }
                  },
                ),
                FilterChip(
                  label: const Text('Power & Shorts'),
                  selected:
                      _selectedPlaybookCategory == DiagnosticCategory.power,
                  onSelected: (selected) {
                    setState(() {
                      _selectedPlaybookCategory =
                          selected ? DiagnosticCategory.power : null;
                    });
                  },
                ),
                FilterChip(
                  label: const Text('Wiring & Polarity'),
                  selected:
                      _selectedPlaybookCategory == DiagnosticCategory.wiring,
                  onSelected: (selected) {
                    setState(() {
                      _selectedPlaybookCategory =
                          selected ? DiagnosticCategory.wiring : null;
                    });
                  },
                ),
                FilterChip(
                  label: const Text('Compile Errors'),
                  selected:
                      _selectedPlaybookCategory == DiagnosticCategory.compile,
                  onSelected: (selected) {
                    setState(() {
                      _selectedPlaybookCategory =
                          selected ? DiagnosticCategory.compile : null;
                    });
                  },
                ),
                FilterChip(
                  label: const Text('Upload Issues'),
                  selected:
                      _selectedPlaybookCategory == DiagnosticCategory.upload,
                  onSelected: (selected) {
                    setState(() {
                      _selectedPlaybookCategory =
                          selected ? DiagnosticCategory.upload : null;
                    });
                  },
                ),
              ],
            ),
          ),
        ),

        // Playbook Expansion Cards
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: playbooks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final pb = playbooks[index];
              final catColor = _getCategoryColor(pb.category);

              return MonsterCard(
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: const EdgeInsets.only(top: 8.0),
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: catColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _formatCategory(pb.category),
                          style: TextStyle(
                            color: catColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      pb.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  children: [
                    // Symptom
                    Text(
                      'Symptom: ${pb.symptomOverview}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),

                    // Golden Rule Callout
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.energyAmber.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.energyAmber, width: 1.2),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star,
                              color: AppColors.energyAmber, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Kid Rule: ${pb.kidRule}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Science explanation
                    Text(
                      pb.theScience,
                      style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 12),

                    // Checklist
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Diagnostic Checklist:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...pb.stepByStepChecklist.map((step) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline,
                                size: 16, color: AppColors.success),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(step,
                                  style: const TextStyle(fontSize: 13)),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
