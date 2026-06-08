import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/expert.dart';
import '../widgets/main_layout.dart';

class LiveChatScreen extends StatefulWidget {
  final Expert expert;
  final VoidCallback onBack;
  final VoidCallback onStartVideoCall;
  final ValueChanged<String> onTabChanged;
  final VoidCallback onSignOut;

  const LiveChatScreen({
    super.key,
    required this.expert,
    required this.onBack,
    required this.onStartVideoCall,
    required this.onTabChanged,
    required this.onSignOut,
  });

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Load initial messages
    _messages.add({
      'sender': 'expert',
      'text': 'Hello! Thanks for booking a consultation session with me. How can I help you today?',
      'time': '18:00',
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'client',
        'text': text,
        'time': _getCurrentTime(),
      });
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Trigger expert response after 1.5 seconds
    Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      String replyText = '';
      if (widget.expert.name.contains('Sarah')) {
        replyText = 'Understood. For your AI and Informatics project, I suggest we review the neural network layers and model optimization techniques. Have you loaded the training dataset?';
      } else if (widget.expert.name.contains('Hermanto')) {
        replyText = 'Got it. For our engineering session, let\'s analyze the thermodynamic equations and heat transfer ratios. Shall we review the schematics first?';
      } else {
        replyText = 'Great. I can guide you through these principles step-by-step. Feel free to tap the video icon in the top right to start our real-time video session!';
      }

      setState(() {
        _messages.add({
          'sender': 'expert',
          'text': replyText,
          'time': _getCurrentTime(),
        });
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _scrollToBottom() {
    Timer(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        return MainLayout(
          activeTab: 'live_chat_list',
          showBottomBar: false,
          onTabChanged: widget.onTabChanged,
          onSignOut: widget.onSignOut,
          child: Scaffold(
            backgroundColor: isDark ? const Color(0xFF131D24) : Colors.transparent,
            appBar: AppBar(
              backgroundColor: isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05),
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.gold),
                onPressed: widget.onBack,
              ),
              title: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(widget.expert.avatar),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: widget.expert.status == 'Available' ? AppColors.gold : AppColors.textSecondary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? const Color(0xFF172128) : const Color(0xFF0F2038),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.expert.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Online',
                          style: TextStyle(
                            color: AppColors.gold.withOpacity(0.8),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.videocam_rounded, color: AppColors.gold, size: 28),
                  onPressed: widget.onStartVideoCall,
                  tooltip: 'Start Video Consultation',
                ),
                const SizedBox(width: 8),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isClient = msg['sender'] == 'client';

                      return Align(
                        alignment: isClient ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isClient
                                ? (isDark ? AppColors.gold.withOpacity(0.1) : Colors.white.withOpacity(0.15))
                                : (isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05)),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: isClient ? const Radius.circular(20) : Radius.zero,
                              bottomRight: isClient ? Radius.zero : const Radius.circular(20),
                            ),
                            border: Border.all(
                              color: isClient ? AppColors.gold.withOpacity(0.3) : Colors.white.withOpacity(0.05),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg['text'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    msg['time'],
                                    style: TextStyle(
                                      color: AppColors.textSecondary.withOpacity(0.5),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_isTyping)
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${widget.expert.name.split(' ')[0]} is typing...',
                        style: TextStyle(
                          color: AppColors.gold.withOpacity(0.8),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 24,
                    top: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF172128).withOpacity(0.4) : Colors.transparent,
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withOpacity(0.05)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: _messageController,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(color: Colors.white30, fontSize: 14),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _sendMessage,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: AppColors.gold,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
