import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guardian_area/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userName = authState.userProfile?.firstName ?? 'Usuario';

    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        children: [
          SvgPicture.asset(
            'assets/images/logo.svg',
            width: 36,
            height: 36,
            colorFilter:
                const ColorFilter.mode(Color(0xFF08273A), BlendMode.srcIn),
          ),
          const Spacer(),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  context.go('/devices');
                },
                child: SvgPicture.asset(
                  'assets/images/mobile-solid.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                      Color(0xFF08273A), BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 5),
              PopupMenuButton<String>(
                icon: CircleAvatar(
                  backgroundColor: const Color(0xFFE8F7FF),
                  radius: 16,
                  child: SvgPicture.asset(
                    'assets/images/user.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF08273A),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                onSelected: (value) {
                  if (value == 'settings') {
                    context.go(
                        '/settings'); // Use context.go for settings navigation
                  } else if (value == 'logout') {
                    ref.read(authProvider.notifier).logout();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'profile',
                    child: Text(userName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                    value: 'settings',
                    child: ListTile(
                      leading: Icon(Icons.settings, color: Colors.black54),
                      title: Text('Settings'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Colors.black54),
                      title: Text('Logout'),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
