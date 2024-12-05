/// Represents a Data Transfer Object (DTO) for a message.
class MessageDto {
  /// The unique identifier for the message.
  final String messageId;

  /// The date and time when the message was sent.
  final DateTime date;

  /// The text content of the message.
  final String text;

  /// The unique identifier for the employee who sent the message.
  final String employeeId;

  /// The employee who sent the message.
  //final EmployeeDto employee;

  /// The unique identifier for the chat associated with the message.
  final String chatId;

  /// The chat associated with the message.
  //final ChatDto chat;



  /// Constructor for MessageDto.
  MessageDto({
    required this.messageId,
    required this.date,
    required this.text,
    required this.employeeId,
    required this.chatId,
    //required this.employee,
    //required this.chat,
  });

  /// Converts a JSON map into a MessageDto.
  factory MessageDto.fromJson(Map<String, dynamic> json) {
    return MessageDto(
      messageId: json['messageId'] as String,
      date: DateTime.parse(json['date'] as String),
      text: json['text'] as String,
      employeeId: json['employeeId'] as String,
      chatId: json['chatId'] as String,
      //employee: EmployeeDto.fromJson(json['employee']),
      //chat: ChatDto.fromJson(json['chat']),
    );
  }

  /// Converts MessageDto to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'date': date.toIso8601String(),
      'text': text,
      'employeeId': employeeId,
      'chatId': chatId,
      //'employee': employee.toJson(),
      //'chat': chat.toJson(),
    };
  }
}