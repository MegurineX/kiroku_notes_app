import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animations/animations.dart';
import '../models/elder.dart';
import '../providers/elder_provider.dart';
import 'package:kiroku_notes_app/screens/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isDrawerOpen = true; // <-- ini untuk toggle drawer di desktop

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth >= 800;
    int crossAxisCount;
    double childAspectRatio;

    if (screenWidth >= 1200) {
      crossAxisCount = 4;
      childAspectRatio = 2.8;
    } else if (screenWidth >= 800) {
      crossAxisCount = 3;
      childAspectRatio = 2.6;
    } else {
      crossAxisCount = 1;
      childAspectRatio = 5.5;
    }

    final elderState = ref.watch(elderNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      drawer: isDesktop ? null : const AppDrawer(),
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop && isDrawerOpen) const AppDrawer(),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        // Icon menu untuk mobile dan desktop
                        Builder(
                          builder:
                              (context) => IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  if (isDesktop) {
                                    setState(() {
                                      isDrawerOpen = !isDrawerOpen;
                                    });
                                  } else {
                                    Scaffold.of(context).openDrawer();
                                  }
                                },
                              ),
                        ),

                        const Spacer(),

                        // Icon baris kanan
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.notifications_none),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.search),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Text(
                        'My Elderly Care',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      child: elderState.when(
                        data:
                            (elders) => GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: childAspectRatio,
                                  ),
                              itemCount: elders.length,
                              itemBuilder: (context, index) {
                                final elder = elders[index];
                                return OpenContainer(
                                  transitionDuration: const Duration(
                                    milliseconds: 500,
                                  ),
                                  transitionType:
                                      ContainerTransitionType.fadeThrough,
                                  closedElevation: 1,
                                  closedShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  closedBuilder:
                                      (context, openContainer) => ListTile(
                                        onTap: openContainer,
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            elder.photoUrl,
                                          ),
                                          radius: 24,
                                        ),
                                        title: Text(
                                          elder.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Age: ${elder.age} | Room: ${elder.roomNumber}',
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed:
                                              () => ref
                                                  .read(
                                                    elderNotifierProvider
                                                        .notifier,
                                                  )
                                                  .deleteElder(elder.id),
                                        ),
                                        tileColor: Colors.grey[200],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                  openBuilder:
                                      (context, _) =>
                                          ElderDetailScreen(elder: elder),
                                );
                              },
                            ),
                        loading:
                            () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        error: (e, _) => Center(child: Text('Error: $e')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: show input form for new Elder
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.teal),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          const ListTile(leading: Icon(Icons.chat), title: Text('Chat')),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ElderDetailScreen extends StatelessWidget {
  final Elder elder;
  const ElderDetailScreen({super.key, required this.elder});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            elder.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Patient Care'),
              Tab(text: 'Activities'),
              Tab(text: 'Reku'),
              Tab(text: 'Admin'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Patient Care Content')),
            Center(child: Text('Daily Activities Content')),
            Center(child: Text('Reku Content')),
            Center(child: Text('Administration Content')),
          ],
        ),
      ),
    );
  }
}
