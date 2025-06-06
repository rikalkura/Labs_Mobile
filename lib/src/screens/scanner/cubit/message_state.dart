abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageReceived extends MessageState {
  final String data;

  MessageReceived(this.data);
}

class MessageError extends MessageState {
  final String message;

  MessageError(this.message);
}
