import 'package:flutter/material.dart';

class AddDeviceDialog extends StatefulWidget {
  const AddDeviceDialog({super.key});

  @override
  AddDeviceDialogState createState() => AddDeviceDialogState();
}

class AddDeviceDialogState extends State<AddDeviceDialog> {
  final _bearerController = TextEditingController();
  final _deviceNameController = TextEditingController();
  String _selectedRole = 'Infant';

  @override
  void dispose() {
    _bearerController.dispose();
    _deviceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pair with Device',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Campo Bearer
            TextField(
              controller: _bearerController,
              decoration: const InputDecoration(
                labelText: 'Bearer',
                hintText: 'Example: Cris...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Campo Device Name
            TextField(
              controller: _deviceNameController,
              decoration: const InputDecoration(
                labelText: 'Device Name',
                hintText: 'Enter a name...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Dropdown para Role
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Choose a role',
                border: OutlineInputBorder(),
              ),
              items: ['Infant', 'Adult'].map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value ?? 'Infant';
                });
              },
            ),
            const SizedBox(height: 24),

            // Botones de Aceptar y Cancelar
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar modal
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final bearer = _bearerController.text;
                    final deviceName = _deviceNameController.text;
                    final role = _selectedRole;

                    print("Adding device with Bearer: $bearer, Device Name: $deviceName, Role: $role");
                    // Lógica para guardar el dispositivo o enviar la data

                    Navigator.of(context).pop(); // Cerrar modal
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF08273A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Accept'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
