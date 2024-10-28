import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guardian_area/features/auth/presentation/providers/auth_provider.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obteniendo el estado del usuario desde el proveedor de autenticación
    final authState = ref.watch(authProvider);

    // Datos de usuario
    final userName = authState.userProfile?.firstName ?? 'Usuario';
    const userProfileImage = 'assets/images/no-image.jpg';

    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        children: [
          SvgPicture.asset(
            'assets/images/logo.svg',
            width: 36,
            height: 36,
            colorFilter: const ColorFilter.mode(Color(0xFF08273A), BlendMode.srcIn),

          ),
          
          const Spacer(),

          // Foto de perfil con Popup Menu
          PopupMenuButton<String>(
            icon: const CircleAvatar(
              backgroundImage: AssetImage(userProfileImage),
            ),
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.pushNamed(context, '/settings');
              } else if (value == 'logout') {
                ref.read(authProvider.notifier).logout();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'profile',
                child: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings, color: Colors.black54),
                  title: Text('Configuración'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.black54),
                  title: Text('Cerrar Sesión'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
