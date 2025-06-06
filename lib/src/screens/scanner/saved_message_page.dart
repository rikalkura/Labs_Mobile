import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/message_cubit.dart';
import 'cubit/message_state.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MessageCubit()..readFromUSB(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Last message from ESP32')),
        body: BlocBuilder<MessageCubit, MessageState>(
          builder: (context, state) {
            if (state is MessageLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MessageError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(fontSize: 18, color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (state is MessageReceived) {
              return Center(
                child: Text(
                  state.data,
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return const Center(child: Text("Initializing..."));
            }
          },
        ),
      ),
    );
  }
}
