import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/main_layout.dart';

class ChatScreen extends StatefulWidget {
  final int? initialExpertId;

  const ChatScreen({
    super.key,
    this.initialExpertId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Mock chat list data
  final List<Map<String, dynamic>> _threads = [
    {
      'id': '1',
      'name': 'Prof. Dr. Hermanto',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop',
      'specialty': 'Teknik Mesin & Termodinamika',
      'lastMessage': 'Please prepare your fluid mechanics draft.',
      'time': '1 hour ago',
      'unread': 0,
      'messages': [
        {'isMe': false, 'text': 'Hello! Please prepare your fluid mechanics draft for our session.'},
        {'isMe': true, 'text': 'Will do, Professor. Thank you!'},
      ]
    },
    {
      'id': '2',
      'name': 'Dr. Sarah Amelia',
      'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop',
      'specialty': 'Research Expert',
      'lastMessage': 'Hello! Is the session scheduled for today?',
      'time': '10 min ago',
      'unread': 1,
      'messages': [
        {'isMe': false, 'text': 'Hello! Welcome to research consultation.'},
        {'isMe': true, 'text': 'Hi doctor, yes thank you!'},
        {'isMe': false, 'text': 'Hello! Is the session scheduled for today?'},
      ]
    },
    {
      'id': '3',
      'name': 'Ir. Ahmad Fauzi',
      'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop',
      'specialty': 'Thesis Reviewer',
      'lastMessage': 'Thanks for the feedback.',
      'time': '2 hours ago',
      'unread': 0,
      'messages': [
        {'isMe': true, 'text': 'I have sent the thesis report draft.'},
        {'isMe': false, 'text': 'Thanks for the feedback.'},
      ]
    },
    {
      'id': '4',
      'name': 'Admin Maestro',
      'avatar': '',
      'specialty': 'Support Team',
      'lastMessage': 'Welcome to Maestronesia! Let us know if you need help.',
      'time': 'Yesterday',
      'unread': 0,
      'messages': [
        {'isMe': false, 'text': 'Welcome to Maestronesia! Let us know if you need help.'},
      ]
    }
  ];

  Map<String, dynamic>? _selectedThread;
  final TextEditingController _messageCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final argId = ModalRoute.of(context)?.settings.arguments as int?;
      final targetId = widget.initialExpertId ?? argId;
      if (targetId != null) {
        final targetThreadId = targetId.toString();
        final index = _threads.indexWhere((t) => t['id'] == targetThreadId);
        if (index != -1) {
          _selectedThread = _threads[index];
          _threads[index]['unread'] = 0;
        }
      }
    }
  }

  void _selectThread(Map<String, dynamic> thread) {
    setState(() {
      _selectedThread = thread;
      thread['unread'] = 0;
    });
    _scrollToBottom();
  }

  void _sendMessage() {
    final text = _messageCtrl.text.trim();
    if (text.isEmpty || _selectedThread == null) return;

    setState(() {
      _selectedThread!['messages'].add({'isMe': true, 'text': text});
      _selectedThread!['lastMessage'] = text;
      _selectedThread!['time'] = 'Just now';
      _messageCtrl.clear();
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
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
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        return MainLayout(
          activeTab: 'chat',
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: isDark ? const Color(0xFF0B141C) : Colors.transparent,
              child: _selectedThread == null
                  ? _buildThreadList(isDark)
                  : _buildChatDetail(isDark),
            ),
          ),
        );
      },
    );
  }

  Widget _buildThreadList(bool isDark) {
    final isDesktop = MediaQuery.of(context).size.width > 768;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktop) ...[
                const Text(
                  'Inbox Messages',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Color(0xFFBBCAC1)),
                    hintText: 'Search chats...',
                    hintStyle: TextStyle(color: Colors.white30, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _threads.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final thread = _threads[index];
              final hasUnread = thread['unread'] > 0;

              return InkWell(
                onTap: () => _selectThread(thread),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: hasUnread
                          ? AppColors.gold.withOpacity(0.3)
                          : Colors.white.withOpacity(0.05),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundImage: thread['avatar'].isNotEmpty
                            ? NetworkImage(thread['avatar'])
                            : null,
                        backgroundColor: AppColors.gold.withOpacity(0.1),
                        child: thread['avatar'].isEmpty
                            ? const Icon(Icons.person, color: AppColors.gold)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  thread['name'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  thread['time'],
                                  style: const TextStyle(
                                    color: Color(0xFFBBCAC1),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              thread['specialty'].toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              thread['lastMessage'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: hasUnread ? Colors.white : const Color(0xFFBBCAC1),
                                fontSize: 12,
                                fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
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
          ),
        ),
      ],
    );
  }

  Widget _buildChatDetail(bool isDark) {
    final messages = _selectedThread!['messages'] as List<dynamic>;

    return Column(
      children: [
        // Thread header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05),
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.gold),
                onPressed: () {
                  setState(() {
                    _selectedThread = null;
                  });
                },
              ),
              CircleAvatar(
                radius: 18,
                backgroundImage: _selectedThread!['avatar'].isNotEmpty
                    ? NetworkImage(_selectedThread!['avatar'])
                    : null,
                backgroundColor: AppColors.gold.withOpacity(0.1),
                child: _selectedThread!['avatar'].isEmpty
                    ? const Icon(Icons.person, color: AppColors.gold, size: 18)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedThread!['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _selectedThread!['specialty'],
                      style: const TextStyle(
                        color: Color(0xFFBBCAC1),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Message List
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              final isMe = msg['isMe'] as bool;

              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? AppColors.gold
                        : (isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05)),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: isMe ? const Radius.circular(20) : Radius.zero,
                      bottomRight: isMe ? Radius.zero : const Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    msg['text'] as String,
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Message Input
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24, top: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0B141C) : Colors.transparent,
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
                    controller: _messageCtrl,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  width: 48,
                  height: 48,
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
    );
  }
}
