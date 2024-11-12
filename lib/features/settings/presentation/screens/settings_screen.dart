import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guardian_area/features/auth/presentation/providers/auth_provider.dart';
import 'package:guardian_area/features/settings/presentation/widgets/save_change_modal.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _nameController;
  late TextEditingController _surnameController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authState = ref.watch(authProvider);
    final userProfile = authState.userProfile;

    if (userProfile != null) {
      _emailController.text = userProfile.email;
      _nameController.text = userProfile.firstName;
      _surnameController.text = userProfile.lastName;
    }
  }

  void _resetFields() {
    final authState = ref.read(authProvider);
    final userProfile = authState.userProfile;

    if (userProfile != null) {
      _emailController.text = userProfile.email;
      _passwordController.clear();
      _confirmPasswordController.clear();
      _nameController.text = userProfile.firstName;
      _surnameController.text = userProfile.lastName;
    }
  }

  void _showSaveChangesModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => SaveChangesModal(
        onCancel: () {
          _resetFields();
        },
        onSave: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final userProfile = authState.userProfile;

    if (userProfile == null) {
      return const Center(child: Text('User not authenticated'));
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings',
              style: TextStyle(
                  color: Color(0xFF08273A),
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // !Selector de imagen de perfil
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFE8F7FF),
                      radius: 60,
                      child: SvgPicture.asset(
                        'assets/images/user.svg',
                        width: 80,
                        height: 80,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF08273A),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          // TODO: Implementar selección de imagen
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Text(
                            'SELECT IMAGE',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // !Email
                _buildTextField(
                  label: 'Email',
                  controller: _emailController,
                  icon: Icons.email,
                  isObscure: false,
                  isEnabled: true,
                ),
                const SizedBox(height: 10),
                _buildPasswordField(
                  label: 'Password',
                  controller: _passwordController,
                  isObscure: _obscurePassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                const SizedBox(height: 10),
                _buildPasswordField(
                  label: 'New Password',
                  controller: _passwordController,
                  isObscure: _obscurePassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                const SizedBox(height: 10),
                _buildPasswordField(
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  isObscure: _obscureConfirmPassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: 'Name',
                  controller: _nameController,
                  icon: Icons.person,
                  isObscure: false,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: 'Surnames',
                  controller: _surnameController,
                  icon: Icons.person_outline,
                  isObscure: false,
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () => _showSaveChangesModal(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF08273A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isObscure,
    bool isEnabled = true,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      enabled: isEnabled,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isObscure,
    required VoidCallback onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(
            isObscure ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
