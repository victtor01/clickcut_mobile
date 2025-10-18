import 'dart:ui';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const _PlaceholderPage(title: 'Início', icon: Icons.home_rounded),
    const _PlaceholderPage(
        title: 'Serviços', icon: Icons.design_services_rounded),
    const _PlaceholderPage(title: 'Agenda', icon: Icons.calendar_month_rounded),
    const _PlaceholderPage(title: 'Perfil', icon: Icons.person_rounded),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Brightness iconBrightness =
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: iconBrightness,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: iconBrightness,
      ),
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            Center(
              child: _pages.elementAt(_selectedIndex),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      height: 78,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainer
                            .withOpacity(0.8),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _NavItem(
                              icon: Iconsax.home,
                              selectedIcon: Iconsax.home1,
                              label: 'Home',
                              isSelected: _selectedIndex == 0,
                              selectedColor: Colors.white,
                              onTap: () => _onItemTapped(0),
                            ),
                            _NavItem(
                              icon: Iconsax.element_4,
                              selectedIcon: Iconsax.element_45,
                              label: 'Serviços',
                              isSelected: _selectedIndex == 1,
                              selectedColor: Colors.white,
                              onTap: () => _onItemTapped(1),
                            ),
                            _AddButton(
                              onTap: () {
                                print('Botão Add Pressionado!');
                              },
                            ),
                            _NavItem(
                              icon: Iconsax.calendar_1,
                              selectedIcon: Iconsax.calendar5,
                              label: 'Agenda',
                              isSelected: _selectedIndex == 2,
                              selectedColor: Colors.white,
                              onTap: () => _onItemTapped(2),
                            ),
                            _NavItem(
                              icon: EvaIcons.personOutline,
                              selectedIcon: EvaIcons.person,
                              label: 'Perfil',
                              isSelected: _selectedIndex == 3,
                              selectedColor: Colors.white,
                              onTap: () => _onItemTapped(3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Usamos Expanded para que ele ocupe o espaço corretamente na Row
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        // Usamos Center para centralizar o botão visualmente menor dentro da área expandida
        child: Center(
          child: Container(
            width: 60, // <-- ADICIONE um width fixo
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final unselectedColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              size: 30,
              isSelected ? selectedIcon : icon,
              color:
                  isSelected ? selectedColor : unselectedColor.withOpacity(0.3),
              shadows: isSelected
                  ? [
                      Shadow(
                        color: selectedColor.withOpacity(
                            0.1), // Sombra com a cor selecionada e opacidade
                        blurRadius:
                            30.0, // Controla o quão "esfumaçada" a sombra é
                      )
                    ]
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderPage({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 80, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(height: 16),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }
}
