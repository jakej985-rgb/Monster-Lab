import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/component_model.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/monster_card.dart';
import '../../shared/widgets/component_image_view.dart';

class PartsScreen extends ConsumerStatefulWidget {
  const PartsScreen({super.key});

  @override
  ConsumerState<PartsScreen> createState() => _PartsScreenState();
}

class _PartsScreenState extends ConsumerState<PartsScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'all';
  final TextEditingController _searchController = TextEditingController();
  static const List<Map<String, String>> _categories = [
    {'id': 'all', 'label': 'All Parts'},
    {'id': 'microcontroller', 'label': 'Main Boards'},
    {'id': 'sensor', 'label': 'Sensors'},
    {'id': 'actuator', 'label': 'Actuators'},
    {'id': 'display', 'label': 'Displays'},
    {'id': 'communication', 'label': 'Comm'},
    {'id': 'switch', 'label': 'Switches'},
    {'id': 'passive', 'label': 'Passives'},
  ];
  late Future<List<ComponentModel>> _componentsFuture;

  @override
  void initState() {
    super.initState();
    _componentsFuture = ref.read(curriculumRepositoryProvider).getComponents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getCategoryColor(String category, ColorScheme colorScheme) {
    switch (category) {
      case 'microcontroller':
        return AppColors.primaryViolet;
      case 'sensor':
        return AppColors.accentCyan;
      case 'actuator':
        return AppColors.success;
      case 'display':
        return AppColors.primaryViolet;
      case 'communication':
        return AppColors.energyAmber;
      case 'switch':
        return AppColors.warning;
      case 'passive':
        return colorScheme.onSurfaceVariant;
      default:
        return AppColors.primaryViolet;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(activeProgressProvider);
    final discoveredIds = progress?.discoveredComponentIds ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parts Lab',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: FutureBuilder<List<ComponentModel>>(
        future: _componentsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final allComponents = snapshot.data!;

          // Filter by category and search query
          final filteredComponents = allComponents.where((comp) {
            final matchesCategory = _selectedCategory == 'all' ||
                comp.category == _selectedCategory;
            final query = _searchQuery.trim().toLowerCase();
            if (query.isEmpty) return matchesCategory;

            final matchesName = comp.name.toLowerCase().contains(query);
            final matchesPartNumber =
                comp.partNumber.toLowerCase().contains(query);
            final matchesNumber = comp.peripheralNumber.toString() == query ||
                '#${comp.peripheralNumber}' == query ||
                '#${comp.peripheralNumber.toString().padLeft(2, '0')}' == query;

            return matchesCategory &&
                (matchesName || matchesPartNumber || matchesNumber);
          }).toList();

          return Column(
            children: [
              // Search & Filter Header
              // GtkSearchEntry Styled Input
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: SizedBox(
                  height: 38,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Search parts by name, number, or chip...',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.6),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              tooltip: 'Clear search',
                              icon: const Icon(Icons.clear, size: 16),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF282C34)
                          : const Color(0xFFF0F2F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF444B59)
                              : const Color(0xFFDCDCDC),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF444B59)
                              : const Color(0xFFDCDCDC),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 0),
                    ),
                  ),
                ),
              ),

              // Discovery Progress Banner
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryViolet.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.primaryViolet.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: AppColors.energyAmber, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Encyclopedia Discovery',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${discoveredIds.length} / ${allComponents.length}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: AppColors.primaryViolet,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: allComponents.isEmpty
                                    ? 0
                                    : discoveredIds.length /
                                        allComponents.length,
                                minHeight: 6,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppColors.energyAmber),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Category Filter Tabs (Responsive Wrap - No side scrolling)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final cat in _categories)
                      ChoiceChip(
                        label: Text(
                          cat['label']!,
                          style: TextStyle(
                            color: _selectedCategory == cat['id']
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: _selectedCategory == cat['id']
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                        selected: _selectedCategory == cat['id'],
                        selectedColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        showCheckmark: false,
                        onSelected: (_) {
                          setState(() => _selectedCategory = cat['id']!);
                        },
                      ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Grid Content
              Expanded(
                child: filteredComponents.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 56,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant),
                            const SizedBox(height: 12),
                            const Text(
                              'No components found',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Try searching for a different keyword or category.',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                            ),
                          ],
                        ),
                      )
                    : Builder(
                        builder: (context) {
                          final textScale =
                              MediaQuery.textScalerOf(context).scale(1.0);
                          final responsiveRatio = (0.72 /
                                  (textScale > 1.0 ? (textScale * 0.9) : 1.0))
                              .clamp(0.55, 0.85);
                          final screenWidth = MediaQuery.sizeOf(context).width;

                          return GridView.builder(
                            padding: const EdgeInsets.all(16.0),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: screenWidth >= 1200
                                  ? 5
                                  : screenWidth >= 900
                                      ? 4
                                      : screenWidth >= 600
                                          ? 3
                                          : 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: responsiveRatio,
                            ),
                            itemCount: filteredComponents.length,
                            itemBuilder: (context, index) {
                              final comp = filteredComponents[index];
                              final isDiscovered =
                                  discoveredIds.contains(comp.id);
                              final catColor = _getCategoryColor(
                                  comp.category, Theme.of(context).colorScheme);

                              return GestureDetector(
                                onSecondaryTapUp: (details) {
                                  final overlay = Overlay.of(context)
                                      .context
                                      .findRenderObject() as RenderBox?;
                                  if (overlay == null) return;
                                  showMenu(
                                    context: context,
                                    position: RelativeRect.fromRect(
                                      details.globalPosition &
                                          const Size(40, 40),
                                      Offset.zero & overlay.size,
                                    ),
                                    items: [
                                      PopupMenuItem<void>(
                                        onTap: () =>
                                            context.push('/parts/${comp.id}'),
                                        child: const Row(
                                          children: [
                                            Icon(Icons.info_outline, size: 16),
                                            SizedBox(width: 8),
                                            Text('Inspect Component'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<void>(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                              text: comp.partNumber));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Copied ${comp.partNumber} to clipboard'),
                                              duration:
                                                  const Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(Icons.copy, size: 16),
                                            SizedBox(width: 8),
                                            Text('Copy Part Number'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<void>(
                                        onTap: () =>
                                            context.push(RoutePaths.build),
                                        child: const Row(
                                          children: [
                                            Icon(Icons.precision_manufacturing,
                                                size: 16),
                                            SizedBox(width: 8),
                                            Text('Open Build Studio'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                child: MonsterCard(
                                  semanticLabel:
                                      '${comp.name}, peripheral #${comp.peripheralNumber}, category ${comp.category}, ${isDiscovered ? "Found" : "Not yet found"}',
                                  onTap: () =>
                                      context.push('/parts/${comp.id}'),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: catColor.withValues(
                                                  alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              '#${comp.peripheralNumber.toString().padLeft(2, '0')}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                                color: catColor,
                                              ),
                                            ),
                                          ),
                                          if (isDiscovered)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.success
                                                    .withValues(alpha: 0.15),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.check_circle,
                                                      size: 12,
                                                      color: AppColors.success),
                                                  SizedBox(width: 3),
                                                  Text(
                                                    'FOUND',
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors.success,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          else if (comp
                                              .safety.requiresParentUnlock)
                                            const Icon(Icons.shield,
                                                size: 16,
                                                color: AppColors.warning)
                                          else
                                            const SizedBox.shrink(),
                                        ],
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: ComponentImageView(
                                            imagePath: comp.primaryImage,
                                            width: 56,
                                            height: 56,
                                            category: comp.category,
                                            semanticLabel:
                                                comp.imageDescription ??
                                                    '${comp.name} photo',
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        comp.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            height: 1.2),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              comp.partNumber,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                  fontSize: 11),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surfaceContainerHighest,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              comp.voltage ==
                                                      OperatingVoltage.v3_3
                                                  ? '3.3V'
                                                  : comp.voltage ==
                                                          OperatingVoltage.v5
                                                      ? '5V'
                                                      : 'Dual',
                                              style: const TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
