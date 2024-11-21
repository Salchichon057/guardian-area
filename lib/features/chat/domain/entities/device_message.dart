class DeviceMessage {
  final String message;

  DeviceMessage({
    required this.message,
  });

  factory DeviceMessage.fromJson(Map<String, dynamic> json) {
    return DeviceMessage(
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
