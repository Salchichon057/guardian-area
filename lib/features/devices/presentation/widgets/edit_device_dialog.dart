import 'package:flutter/material.dart';
import 'package:guardian_area/features/devices/domain/entities/device.dart';

class EditDeviceDialog extends StatefulWidget {
  final Device device;

  const EditDeviceDialog({super.key, required this.device});

  @override
  State<EditDeviceDialog> createState() => _EditDeviceDialogState();
}

class _EditDeviceDialogState extends State<EditDeviceDialog> {
  late TextEditingController bearerController;
  late TextEditingController nameController;
  late String selectedRole;

  @override
  void initState() {
    super.initState();

    bearerController = TextEditingController(text: widget.device.bearer);
    nameController = TextEditingController(text: widget.device.nickname);

    selectedRole = (widget.device.careMode == 'INFANT' ||
            widget.device.careMode == 'ADULT')
        ? widget.device.careMode
        : 'INFANT';
  }

  @override
  void dispose() {
    bearerController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Device',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Campo de Bearer
            TextFormField(
              controller: bearerController,
              decoration: InputDecoration(
                labelText: 'Bearer',
                labelStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
                hintText: 'Ejemplo: Cris...',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),

            // Campo de Nombre del Dispositivo
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Device Name',
                labelStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
                hintText: 'Enter a name...',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),

            // Dropdown para seleccionar rol
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: InputDecoration(
                labelText: 'Choose a role',
                labelStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
              items: ['INFANT', 'ADULT']
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(
                          role,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedRole = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implementar la lógica de actualización aquí
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF08273A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
