import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/component_model.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/monster_card.dart';
import '../../shared/widgets/component_image_view.dart';

class PartDetailScreen extends ConsumerStatefulWidget {
  final String componentId;

  const PartDetailScreen({super.key, required this.componentId});

  @override
  ConsumerState<PartDetailScreen> createState() => _PartDetailScreenState();
}

class _PartDetailScreenState extends ConsumerState<PartDetailScreen> {
  late Future<ComponentModel?> _componentFuture;
  bool _isDiscovering = false;

  @override
  void initState() {
    super.initState();
    _componentFuture = ref
        .read(curriculumRepositoryProvider)
        .getComponentById(widget.componentId);
  }

  @override
  void didUpdateWidget(covariant PartDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.componentId != widget.componentId) {
      _componentFuture = ref
          .read(curriculumRepositoryProvider)
          .getComponentById(widget.componentId);
    }
  }

  Color _getPinColor(PinType type) {
    switch (type) {
      case PinType.power:
        return AppColors.wirePower5V;
      case PinType.ground:
        return AppColors.wireGround;
      case PinType.digitalIn:
      case PinType.digitalOut:
        return AppColors.wireDigital;
      case PinType.analogIn:
        return AppColors.wireAnalog;
      case PinType.i2c:
        return AppColors.wireI2C;
      case PinType.spi:
        return AppColors.wireSPI;
      case PinType.uart:
        return const Color(0xFF7B1FA2); // Purple (UART)
      case PinType.passive:
        return AppColors.wireSignalAlt;
    }
  }

  String _getWireColorName(PinType type) {
    switch (type) {
      case PinType.power:
        return 'Red Wire';
      case PinType.ground:
        return 'Dark Slate Wire';
      case PinType.digitalIn:
      case PinType.digitalOut:
        return 'Green Wire';
      case PinType.analogIn:
        return 'Yellow Wire';
      case PinType.i2c:
        return 'Blue Wire';
      case PinType.spi:
        return 'Orange Wire';
      case PinType.uart:
        return 'Purple Wire';
      case PinType.passive:
        return 'Grey Wire';
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(activeProgressProvider);
    final safetyAuthorizations = ref.watch(safetyAuthorizationsProvider);
    final isDiscovered =
        progress?.discoveredComponentIds.contains(widget.componentId) ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Component Inspector',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: FutureBuilder<ComponentModel?>(
        future: _componentFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final comp = snapshot.data;
          if (comp == null) {
            return const Center(child: Text('Component not found'));
          }

          return _buildContent(
            context,
            comp,
            safetyAuthorizations,
            isDiscovered,
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ComponentModel comp,
    Map<String, bool> safetyAuthorizations,
    bool isDiscovered,
  ) {
    final requiresParentAuthorization = comp.safety.requiresParentUnlock ||
        comp.safety.level == SafetyLevel.restrictedAdultSupervision;
    final safetyKey = _safetyGateKey(comp);
    final isParentAuthorized = !requiresParentAuthorization ||
        (safetyAuthorizations[safetyKey] ?? false);
    final showDetails = isDiscovered && isParentAuthorized;

    final children = <Widget>[
      _buildHeaderCard(context, comp, isDiscovered),
    ];

    if (requiresParentAuthorization && !isParentAuthorized) {
      children.add(const SizedBox(height: 16));
      children.add(_buildParentSafetyLockCard(safetyKey));
    }

    children.add(const SizedBox(height: 16));
    children.add(_buildVisualsCard(
      context,
      comp,
      showDetails,
      isDiscovered,
      isParentAuthorized,
    ));

    if (!isDiscovered && isParentAuthorized) {
      children.add(const SizedBox(height: 16));
      children.add(_buildLockedTeaserCard(context));
    }

    if (showDetails) {
      children.addAll(_buildEncyclopediaDetails(context, comp));
    }

    children.add(const SizedBox(height: 24));

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: children,
    );
  }

  Widget _buildBadge({
    required Widget child,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: child,
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    ComponentModel comp,
    bool isDiscovered,
  ) {
    return MonsterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ComponentImageView(
                imagePath: comp.primaryImage,
                width: 64,
                height: 64,
                category: comp.category,
                semanticLabel:
                    comp.imageDescription ?? '${comp.name} thumbnail',
                borderRadius: BorderRadius.circular(16),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildBadge(
                          backgroundColor:
                              AppColors.primaryViolet.withValues(alpha: 0.15),
                          child: Text(
                            '#${comp.peripheralNumber.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: AppColors.primaryViolet,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildBadge(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          child: Text(
                            comp.partNumber,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildBadge(
                          backgroundColor:
                              AppColors.energyAmber.withValues(alpha: 0.15),
                          child: Text(
                            comp.voltage == OperatingVoltage.v3_3
                                ? '3.3V'
                                : comp.voltage == OperatingVoltage.v5
                                    ? '5V'
                                    : '3.3V / 5V',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: AppColors.energyAmber,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      comp.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isDiscovered) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Discovered in your Lab Encyclopedia!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVisualsCard(
    BuildContext context,
    ComponentModel comp,
    bool showDetails,
    bool isDiscovered,
    bool isParentAuthorized,
  ) {
    final visuals = <Widget>[
      Row(
        children: [
          const Icon(Icons.photo_camera,
              color: AppColors.primaryViolet, size: 20),
          const SizedBox(width: 8),
          Text(
            'Hardware Photo & Visuals',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryViolet,
                ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Center(
        child: ComponentImageView(
          imagePath: comp.primaryImage,
          height: 200,
          width: double.infinity,
          category: comp.category,
          semanticLabel:
              comp.imageDescription ?? 'Hardware photo of ${comp.name}',
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ];

    if (!isDiscovered && isParentAuthorized) {
      visuals.add(const SizedBox(height: 16));
      visuals.add(_buildDiscoveryAction(context, comp));
    }

    if (showDetails && comp.detailImages.isNotEmpty) {
      visuals.add(const SizedBox(height: 16));
      visuals.add(
        Row(
          children: [
            const Icon(Icons.account_tree_outlined,
                color: AppColors.accentCyanDark, size: 18),
            const SizedBox(width: 8),
            Text(
              'Diagram & Pinout Reference',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentCyanDark,
                  ),
            ),
          ],
        ),
      );
      visuals.add(const SizedBox(height: 8));
      visuals.add(
        Center(
          child: ComponentImageView(
            imagePath: comp.detailImages.first,
            height: 160,
            width: double.infinity,
            category: comp.category,
            semanticLabel: 'Diagram and pinout for ${comp.name}',
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }

    return MonsterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: visuals,
      ),
    );
  }

  List<Widget> _buildEncyclopediaDetails(
    BuildContext context,
    ComponentModel comp,
  ) {
    final miniExp = comp.miniExperiment;
    final details = <Widget>[
      const SizedBox(height: 16),

      // Safety Classification Card
      _buildSafetyCard(comp.safety),

      // Real-World Analogy & Description
      _buildSectionHeader('How it Works & Analogy'),
      MonsterCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(comp.description,
                style: const TextStyle(fontSize: 14, height: 1.5)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.accentCyan.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline,
                      color: AppColors.accentCyanDark, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      comp.realWorldAnalogy,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Color-Coded Pinout Table
      _buildRowSectionHeader(
        title: 'Pin Connections & Wires',
        badge: _buildBadge(
          backgroundColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Text(
            '${comp.pinout.length} Pins',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),

      MonsterCard(
        child: Column(
          children: [
            ...comp.pinout.map((pin) {
              final pinColor = _getPinColor(pin.type);
              final wireColorName = _getWireColorName(pin.type);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    // Wire color indicator dot
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: pinColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: pinColor.withValues(alpha: 0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Pin Name pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color:
                                Theme.of(context).colorScheme.outlineVariant),
                      ),
                      child: Text(
                        pin.pinName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Description & Wire Color
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pin.description,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: pinColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black26),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                wireColorName,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    ];

    if (comp.wiringGuidance != null) {
      details.add(const SizedBox(height: 16));
      details.add(const Text('Wiring Instructions',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)));
      details.add(const SizedBox(height: 8));
      details.add(MonsterCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.cable, color: AppColors.primaryViolet, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                comp.wiringGuidance!,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
          ],
        ),
      ));
    }

    if (comp.commonMistakes.isNotEmpty) {
      details.add(_buildSectionHeader('Common Mistakes to Avoid'));
      details.add(MonsterCard(
        child: Column(
          children: comp.commonMistakes.map((mistake) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: AppColors.warning, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      mistake,
                      style: const TextStyle(fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ));
    }

    if (miniExp != null) {
      details.add(_buildRowSectionHeader(
        title: 'Mini Experiment',
        badge: _buildBadge(
          backgroundColor: AppColors.energyAmber.withValues(alpha: 0.15),
          child: const Text(
            'QUICK TEST',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.energyAmber,
            ),
          ),
        ),
      ));
      details.add(const SizedBox(height: 8));
      details.add(_buildMiniExperimentCard(context, miniExp));
    }

    if (comp.projectIds.isNotEmpty) {
      details.add(const SizedBox(height: 16));
      details.add(_buildFeaturedProjectsCard(context, comp.projectIds));
    }

    return details;
  }

  Widget _buildMiniExperimentCard(
    BuildContext context,
    Map<String, dynamic> miniExp,
  ) {
    final title = miniExp['title'] as String? ?? 'Component Test';
    return MonsterCard(
      key: const ValueKey('mini_experiment_card'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Experiment title heading
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Circuit: ${miniExp['circuit'] ?? ''}',
            style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),

          // Code Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E), // Dark code background
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Arduino C++',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy,
                          size: 18, color: Colors.white70),
                      tooltip: 'Copy Sketch',
                      constraints:
                          const BoxConstraints(minWidth: 48, minHeight: 48),
                      onPressed: () {
                        final code = miniExp['code'] as String? ?? '';
                        Clipboard.setData(ClipboardData(text: code));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sketch code copied to clipboard!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const Divider(color: Colors.white24, height: 12),
                Text(
                  miniExp['code'] as String? ?? '',
                  style: const TextStyle(
                    color: Color(0xFF89DDFF),
                    fontFamily: 'monospace',
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Expected Output
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppColors.accentCyan.withValues(alpha: 0.25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline,
                    color: AppColors.accentCyanDark, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Expected Output: ${miniExp['expectedOutput'] ?? ''}',
                    style: const TextStyle(fontSize: 12, height: 1.35),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedProjectsCard(
    BuildContext context,
    List<String> projectIds,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Featured Projects',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: projectIds.map((pId) {
            return ActionChip(
              avatar: const Icon(Icons.build_circle,
                  size: 18, color: AppColors.primaryViolet),
              label: Text(
                'Project #${pId.replaceAll('proj_', '')}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              onPressed: () => context.push('/build/$pId'),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _safetyGateKey(ComponentModel component) {
    final text =
        '${component.name} ${component.partNumber} ${component.safety.hazards.join(' ')}'
            .toLowerCase();
    if (text.contains('laser') || text.contains('ky-008')) return 'laser';
    if (text.contains('gas') ||
        text.contains('mq-3') ||
        text.contains('mq-9') ||
        text.contains('combustible')) {
      return 'gas';
    }
    return 'relay';
  }

  String _safetyGateLabel(String key) {
    switch (key) {
      case 'laser':
        return 'laser authorization';
      case 'gas':
        return 'gas/flame sensor authorization';
      default:
        return 'high-current relay authorization';
    }
  }

  Widget _buildParentSafetyLockCard(String safetyKey) {
    return MonsterCard(
      key: const Key('parent_safety_lock_card'),
      color: AppColors.danger.withValues(alpha: 0.08),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(
          Icons.shield_outlined,
          color: AppColors.danger,
          size: 28,
        ),
        title: const Text(
          'Parent Authorization Required',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            'A grown-up must enable ${_safetyGateLabel(safetyKey)} '
            'in the Parent Dashboard before this component can be used.',
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
        ),
      ),
    );
  }

  Widget _buildLockedTeaserCard(BuildContext context) {
    return MonsterCard(
      key: const Key('locked_teaser_card'),
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.energyAmber.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.lock_outline,
              color: AppColors.energyAmber, size: 24),
        ),
        title: const Text(
          'Component Locked in Lab Kit',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.1,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            'Find this part in your physical kit and tap "Discover Part" '
            'above to unlock full pinout schematics, safety ratings, '
            'wiring guides, and interactive experiments!',
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyCard(SafetyClassification safety) {
    Color levelColor;
    String levelLabel;
    IconData levelIcon;

    switch (safety.level) {
      case SafetyLevel.safe:
        levelColor = AppColors.success;
        levelLabel = 'Child-Safe Component';
        levelIcon = Icons.verified_user;
        break;
      case SafetyLevel.caution:
        levelColor = AppColors.warning;
        levelLabel = 'Caution Advised';
        levelIcon = Icons.warning_amber_rounded;
        break;
      case SafetyLevel.restrictedAdultSupervision:
        levelColor = AppColors.danger;
        levelLabel = 'Adult Supervision Required';
        levelIcon = Icons.shield_outlined;
        break;
    }

    return MonsterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(levelIcon, color: levelColor, size: 22),
              const SizedBox(width: 8),
              Text(
                levelLabel,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: levelColor,
                ),
              ),
              const Spacer(),
              if (safety.requiresParentUnlock)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'PARENT UNLOCK',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.danger,
                    ),
                  ),
                ),
            ],
          ),
          if (safety.hazards.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...safety.hazards.map((h) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.arrow_right, size: 18, color: levelColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          h,
                          style: const TextStyle(fontSize: 13, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
          if (safety.childSafeAlternative != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Safe Alternative: ${safety.childSafeAlternative}',
                style:
                    const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRowSectionHeader({
    required String title,
    required Widget badge,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Experiment title heading
          Text(title,
              style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          badge,
        ],
      ),
    );
  }

  Widget _buildDiscoveryAction(BuildContext context, ComponentModel comp) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        key: const Key('discover_button'),
        onPressed:
            _isDiscovering ? null : () => _performDiscovery(context, comp),
        icon: _isDiscovering
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.star_rounded, color: AppColors.energyAmber),
        label: Text(
          _isDiscovering ? 'Discovering...' : 'Discover Part (+25 XP)',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryViolet,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Future<void> _performDiscovery(
    BuildContext context,
    ComponentModel comp,
  ) async {
    setState(() => _isDiscovering = true);
    try {
      await ref
          .read(activeProgressProvider.notifier)
          .discoverComponent(comp.id, 25);
      ref.read(soundEffectsProvider).success();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                Icon(Icons.star_rounded, color: AppColors.energyAmber),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Component Discovered! +25 XP awarded to your profile!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDiscovering = false);
      }
    }
  }
}
