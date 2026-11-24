import 'package:flutter/material.dart';

void main() {
  runApp(const PlantCareApp());
}

class PlantCareApp extends StatelessWidget {
  const PlantCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    const forest = Color(0xFF245B42);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlantCare',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: forest,
          primary: forest,
          surface: const Color(0xFFF7FAF6),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7FAF6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7FAF6),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDCE7DE)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDCE7DE)),
          ),
        ),
      ),
      home: const PlantCareShell(),
    );
  }
}

class Plant {
  Plant({
    required this.name,
    required this.kind,
    required this.lastWatered,
    required this.intervalDays,
    required this.icon,
    required this.light,
  });

  final String name;
  final String kind;
  DateTime lastWatered;
  final int intervalDays;
  final IconData icon;
  final String light;

  DateTime get nextWatering =>
      DateTime(lastWatered.year, lastWatered.month, lastWatered.day + intervalDays);

  int get daysUntilWatering {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    return nextWatering.difference(start).inDays;
  }

  bool get needsWater => daysUntilWatering <= 0;
}

class PlantCareShell extends StatefulWidget {
  const PlantCareShell({super.key});

  @override
  State<PlantCareShell> createState() => _PlantCareShellState();
}

class _PlantCareShellState extends State<PlantCareShell> {
  int selectedIndex = 0;

  final List<Plant> plants = [
    Plant(
      name: 'Monstera',
      kind: 'Tropical plant',
      lastWatered: DateTime.now().subtract(const Duration(days: 7)),
      intervalDays: 7,
      icon: Icons.spa_rounded,
      light: 'Bright, indirect light',
    ),
    Plant(
      name: 'Snake Plant',
      kind: 'Succulent',
      lastWatered: DateTime.now().subtract(const Duration(days: 5)),
      intervalDays: 14,
      icon: Icons.eco_rounded,
      light: 'Low to bright indirect light',
    ),
    Plant(
      name: 'Peace Lily',
      kind: 'Flowering plant',
      lastWatered: DateTime.now().subtract(const Duration(days: 6)),
      intervalDays: 7,
      icon: Icons.local_florist_rounded,
      light: 'Medium, indirect light',
    ),
    Plant(
      name: 'Pothos',
      kind: 'Trailing plant',
      lastWatered: DateTime.now().subtract(const Duration(days: 3)),
      intervalDays: 7,
      icon: Icons.grass_rounded,
      light: 'Bright, indirect light',
    ),
  ];

  final titles = const [
    'Overview',
    'My Plants',
    'Watering Schedule',
    'Care Tips',
  ];

  void addPlant(Plant plant) {
    setState(() => plants.add(plant));
  }

  void markWatered(Plant plant) {
    setState(() => plant.lastWatered = DateTime.now());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${plant.name} marked as watered')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(plants: plants, onWater: markWatered, onNavigate: (i) {
        setState(() => selectedIndex = i);
      }),
      PlantsPage(plants: plants, onWater: markWatered, onAdd: addPlant),
      SchedulePage(plants: plants, onWater: markWatered),
      const TipsPage(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const Icon(Icons.spa_rounded, color: Color(0xFF245B42)),
                const SizedBox(width: 9),
                const Text(
                  'PlantCare',
                  style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.4),
                ),
                const Spacer(),
                if (wide)
                  Text(
                    'A little care goes a long way',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF668071),
                        ),
                  ),
              ],
            ),
          ),
          body: Row(
            children: [
              if (wide)
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (i) => setState(() => selectedIndex = i),
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard_rounded),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.local_florist_outlined),
                      selectedIcon: Icon(Icons.local_florist_rounded),
                      label: Text('My Plants'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.calendar_month_outlined),
                      selectedIcon: Icon(Icons.calendar_month_rounded),
                      label: Text('Schedule'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.menu_book_outlined),
                      selectedIcon: Icon(Icons.menu_book_rounded),
                      label: Text('Care Tips'),
                    ),
                  ],
                ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: IndexedStack(index: selectedIndex, children: pages),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (i) => setState(() => selectedIndex = i),
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard_rounded),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.local_florist_outlined),
                      selectedIcon: Icon(Icons.local_florist_rounded),
                      label: 'Plants',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.calendar_month_outlined),
                      selectedIcon: Icon(Icons.calendar_month_rounded),
                      label: 'Schedule',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.menu_book_outlined),
                      selectedIcon: Icon(Icons.menu_book_rounded),
                      label: 'Tips',
                    ),
                  ],
                ),
          floatingActionButton: selectedIndex == 1
              ? FloatingActionButton.extended(
                  onPressed: () => _showAddPlantDialog(context, addPlant),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Plant'),
                )
              : null,
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.plants,
    required this.onWater,
    required this.onNavigate,
  });

  final List<Plant> plants;
  final ValueChanged<Plant> onWater;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final due = plants.where((p) => p.needsWater).toList();
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        Text('Good day, plant lover 👋',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF203B2C),
                )),
        const SizedBox(height: 7),
        const Text('Here is a quick look at your plants today.',
            style: TextStyle(color: Color(0xFF6B7F72))),
        const SizedBox(height: 22),
        LayoutBuilder(builder: (context, c) {
          final count = c.maxWidth > 600 ? 3 : 1;
          return GridView.count(
            crossAxisCount: count,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: count == 1 ? 3.5 : 2.2,
            children: [
              _StatCard(
                label: 'My plants',
                value: '${plants.length}',
                icon: Icons.spa_rounded,
                color: const Color(0xFFE5F1E7),
              ),
              _StatCard(
                label: 'Need watering',
                value: '${due.length}',
                icon: Icons.water_drop_rounded,
                color: const Color(0xFFE5F0F6),
              ),
              _StatCard(
                label: 'On track',
                value: '${plants.length - due.length}',
                icon: Icons.check_circle_rounded,
                color: const Color(0xFFF2EEDF),
              ),
            ],
          );
        }),
        const SizedBox(height: 26),
        _SectionHeader(
          title: 'Today’s care',
          action: 'View schedule',
          onTap: () => onNavigate(2),
        ),
        const SizedBox(height: 12),
        if (due.isEmpty)
          const _EmptyCard(
            icon: Icons.celebration_outlined,
            title: 'You are all caught up!',
            subtitle: 'No plants are due for watering today.',
          )
        else
          ...due.map((plant) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PlantTile(plant: plant, onWater: () => onWater(plant)),
              )),
        const SizedBox(height: 18),
        _SectionHeader(
          title: 'Your collection',
          action: 'See all',
          onTap: () => onNavigate(1),
        ),
        const SizedBox(height: 12),
        ...plants.take(3).map((plant) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PlantTile(plant: plant, onWater: () => onWater(plant)),
            )),
      ],
    );
  }
}

class PlantsPage extends StatelessWidget {
  const PlantsPage({
    super.key,
    required this.plants,
    required this.onWater,
    required this.onAdd,
  });

  final List<Plant> plants;
  final ValueChanged<Plant> onWater;
  final ValueChanged<Plant> onAdd;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        Text('My Plants',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                )),
        const SizedBox(height: 6),
        const Text('Keep your plant collection in one place.',
            style: TextStyle(color: Color(0xFF6B7F72))),
        const SizedBox(height: 20),
        if (plants.isEmpty)
          const _EmptyCard(
            icon: Icons.spa_outlined,
            title: 'No plants yet',
            subtitle: 'Add your first plant to get started.',
          )
        else
          LayoutBuilder(builder: (context, c) {
            final columns = c.maxWidth >= 760 ? 2 : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: plants.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisExtent: 112,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) => PlantTile(
                plant: plants[index],
                onWater: () => onWater(plants[index]),
              ),
            );
          }),
        const SizedBox(height: 90),
      ],
    );
  }
}

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key, required this.plants, required this.onWater});
  final List<Plant> plants;
  final ValueChanged<Plant> onWater;

  @override
  Widget build(BuildContext context) {
    final sorted = [...plants]
      ..sort((a, b) => a.nextWatering.compareTo(b.nextWatering));
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        Text('Watering Schedule',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                )),
        const SizedBox(height: 6),
        const Text('Your next watering dates, calculated from the last watering.',
            style: TextStyle(color: Color(0xFF6B7F72))),
        const SizedBox(height: 20),
        ...sorted.map((plant) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PlantTile(plant: plant, onWater: () => onWater(plant)),
            )),
      ],
    );
  }
}

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  static const tips = [
    ('Check the soil', 'Touch the top layer of soil before watering. If it is still damp, wait a little longer.', Icons.grass_rounded),
    ('Find the right light', 'Most indoor plants do well with bright, indirect light. Avoid harsh direct sun unless the plant needs it.', Icons.wb_sunny_outlined),
    ('Use drainage', 'Choose pots with drainage holes to help prevent water from collecting around the roots.', Icons.water_drop_outlined),
    ('Clean the leaves', 'Gently wipe dusty leaves so your plants can receive light more effectively.', Icons.cleaning_services_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        Text('Care Tips',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                )),
        const SizedBox(height: 6),
        const Text('A few simple habits can help your plants thrive.',
            style: TextStyle(color: Color(0xFF6B7F72))),
        const SizedBox(height: 20),
        ...tips.map((tip) => Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: Color(0xFFE2EBE3)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFE8F2E8),
                      foregroundColor: const Color(0xFF245B42),
                      child: Icon(tip.$3),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tip.$1,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 16)),
                          const SizedBox(height: 5),
                          Text(tip.$2,
                              style: const TextStyle(
                                  color: Color(0xFF65776B), height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class PlantTile extends StatelessWidget {
  const PlantTile({super.key, required this.plant, required this.onWater});
  final Plant plant;
  final VoidCallback onWater;

  @override
  Widget build(BuildContext context) {
    final dueText = plant.daysUntilWatering < 0
        ? 'Overdue by ${plant.daysUntilWatering.abs()} day(s)'
        : plant.daysUntilWatering == 0
            ? 'Water today'
            : 'Water in ${plant.daysUntilWatering} day(s)';
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE2EBE3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFFE8F2E8),
              foregroundColor: const Color(0xFF245B42),
              child: Icon(plant.icon, size: 26),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plant.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 15)),
                  const SizedBox(height: 3),
                  Text(plant.kind,
                      style: const TextStyle(
                          color: Color(0xFF718176), fontSize: 12)),
                  const SizedBox(height: 5),
                  Text(dueText,
                      style: TextStyle(
                        color: plant.needsWater
                            ? const Color(0xFFB36A2E)
                            : const Color(0xFF4D7A5C),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      )),
                ],
              ),
            ),
            if (plant.needsWater)
              TextButton(onPressed: onWater, child: const Text('Watered')),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2EBE3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            foregroundColor: const Color(0xFF245B42),
            child: Icon(icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 21)),
                Text(label,
                    style: const TextStyle(
                        color: Color(0xFF718176), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.action,
    required this.onTap,
  });

  final String title;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 18)),
        ),
        TextButton(onPressed: onTap, child: Text(action)),
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2EBE3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 34, color: const Color(0xFF70A982)),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF718176))),
        ],
      ),
    );
  }
}

Future<void> _showAddPlantDialog(
  BuildContext context,
  ValueChanged<Plant> onAdd,
) async {
  final nameController = TextEditingController();
  final intervalController = TextEditingController(text: '7');
  String kind = 'Indoor plant';
  String light = 'Bright, indirect light';

  final result = await showDialog<Plant>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: const Text('Add a plant'),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Plant name'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: kind,
                  decoration: const InputDecoration(labelText: 'Plant type'),
                  items: const [
                    DropdownMenuItem(value: 'Indoor plant', child: Text('Indoor plant')),
                    DropdownMenuItem(value: 'Succulent', child: Text('Succulent')),
                    DropdownMenuItem(value: 'Flowering plant', child: Text('Flowering plant')),
                    DropdownMenuItem(value: 'Herb', child: Text('Herb')),
                  ],
                  onChanged: (v) => setDialogState(() => kind = v ?? kind),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: intervalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Water every (days)',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: light,
                  decoration: const InputDecoration(labelText: 'Light preference'),
                  items: const [
                    DropdownMenuItem(value: 'Bright, indirect light', child: Text('Bright, indirect light')),
                    DropdownMenuItem(value: 'Medium light', child: Text('Medium light')),
                    DropdownMenuItem(value: 'Low light', child: Text('Low light')),
                  ],
                  onChanged: (v) => setDialogState(() => light = v ?? light),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              final interval = int.tryParse(intervalController.text.trim());
              if (name.isEmpty || interval == null || interval < 1 || interval > 60) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Enter a name and a watering interval from 1 to 60 days.'),
                  ),
                );
                return;
              }
              Navigator.pop(
                context,
                Plant(
                  name: name,
                  kind: kind,
                  lastWatered: DateTime.now(),
                  intervalDays: interval,
                  icon: Icons.spa_rounded,
                  light: light,
                ),
              );
            },
            child: const Text('Add plant'),
          ),
        ],
      ),
    ),
  );

  nameController.dispose();
  intervalController.dispose();
  if (result != null) onAdd(result);
}
