import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guardian_area/features/auth/presentation/providers/auth_provider.dart';
import 'package:guardian_area/features/navigation/infrastructure/datasources/health_stream_datasource_impl.dart';
import 'package:guardian_area/features/navigation/domain/entities/health_measure.dart';
import 'package:guardian_area/features/navigation/presentation/widgets/health_stats_bar.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(105);
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  final HealthStreamDatasourceImpl _datasource = HealthStreamDatasourceImpl(
    baseUrl: 'ws://guardianarea.azurewebsites.net',
  );

  HealthMeasure _healthData = HealthMeasure(bpm: 0, spo2: 0);
  late Stream<HealthMeasure> _healthStream;

  @override
  void initState() {
    super.initState();
    _healthStream =
        _datasource.connectToHealthStream('UJ5AOv3WKh-JW_PFaz_QQ3KkxJ1La5cz');
    _healthStream.listen((data) {
      setState(() {
        _healthData = data;
      });
    });
  }

  @override
  void dispose() {
    _datasource.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Acceder al estado del authProvider
    final authState = ref.watch(authProvider);
    final userName = authState.userProfile?.firstName ?? 'Usuario';

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 36,
                  height: 36,
                  colorFilter: const ColorFilter.mode(
                      Color(0xFF08273A), BlendMode.srcIn),
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
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        if (value == 'settings') {
                          context.go('/settings');
                        } else if (value == 'profile') {
                          context.go('/profile');
                        } else if (value == 'logout') {
                          ref.read(authProvider.notifier).logout();
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'profile',
                          child: Text(
                            userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem<String>(
                          value: 'settings',
                          child: ListTile(
                            leading:
                                Icon(Icons.settings, color: Colors.blueGrey),
                            title: Text(
                              'Settings',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'logout',
                          child: ListTile(
                            leading:
                                Icon(Icons.logout, color: Colors.redAccent),
                            title: Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            color: const Color(0xFF08273A),
            child: HealthStatsBar(
              bpm: _healthData.bpm.toString(),
              spo2: _healthData.spo2.toString(),
            ),
          ),
        ],
      ),
    );
  }
}
