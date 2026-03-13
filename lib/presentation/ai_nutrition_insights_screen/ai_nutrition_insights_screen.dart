import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../models/chat_message_model.dart';
import '../../services/openai_service.dart';
import '../../services/auth_service.dart';
import './widgets/chat_message_bubble_widget.dart';
import './widgets/chat_input_widget.dart';

class AiNutritionInsightsScreen extends StatefulWidget {
  const AiNutritionInsightsScreen({super.key});

  @override
  State<AiNutritionInsightsScreen> createState() =>
      _AiNutritionInsightsScreenState();
}

class _AiNutritionInsightsScreenState extends State<AiNutritionInsightsScreen>
    with SingleTickerProviderStateMixin {
  final List<ChatMessageModel> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;
  String? _userGoal;

  // ✅ Animations (same style as previous screens)
  late final AnimationController _controller;

  // Top (upar se neeche)
  late final Animation<Offset> _appBarSlide;
  late final Animation<double> _appBarFade;

  // Middle (neeche se upar)
  late final Animation<Offset> _contentSlide;
  late final Animation<double> _contentFade;

  // Bottom input (neeche se upar)
  late final Animation<Offset> _inputSlide;
  late final Animation<double> _inputFade;

  @override
  void initState() {
    super.initState();
    _initializeChat();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    // ✅ TOP: AppBar area
    _appBarSlide = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.20, curve: Curves.easeOutCubic),
      ),
    );

    _appBarFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.20, curve: Curves.easeOut),
      ),
    );

    // ✅ CONTENT: Messages list / empty state
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.18, 0.88, curve: Curves.easeOutCubic),
      ),
    );

    _contentFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.18, 0.80, curve: Curves.easeOut),
      ),
    );

    // ✅ BOTTOM: Input section
    _inputSlide = Tween<Offset>(
      begin: const Offset(0, 0.40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.60, 1.00, curve: Curves.easeOutCubic),
      ),
    );

    _inputFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.60, 1.00, curve: Curves.easeOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  Future<void> _initializeChat() async {
    try {
      final user = AuthService.instance.currentUser;
      if (user != null) {
        final profile = await AuthService.instance.getUserProfile(user.id);
        _userGoal = profile?.fitnessGoal;
      }

      setState(() {
        _messages.add(
          ChatMessageModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            role: 'assistant',
            content:
            'Hello! I\'m your Nigerian nutrition AI assistant. I can help you with meal planning, calorie tracking, and healthy Nigerian food choices. What would you like to know?',
            timestamp: DateTime.now(),
          ),
        );
      });
    } catch (e) {
      debugPrint('Error initializing chat: $e');
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      content: text.trim(),
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    _textController.clear();
    _scrollToBottom();

    try {
      final apiMessages = [
        ChatMessage(
          role: 'system',
          content: OpenAIService.instance.getSystemPrompt(_userGoal),
        ),
        ..._messages
            .where((m) => !m.isError)
            .map((m) => ChatMessage(role: m.role, content: m.content)),
      ];

      final response = await OpenAIService.instance.sendChatMessage(
        messages: apiMessages,
      );

      final assistantMessage = ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'assistant',
        content: response,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(assistantMessage);
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessageModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            role: 'assistant',
            content: 'Sorry, I couldn\'t process your request. Please try again.',
            timestamp: DateTime.now(),
            isError: true,
          ),
        );
        _isLoading = false;
      });
      _scrollToBottom();
    }
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

  Widget _animatedEntry({
    required Animation<Offset> slide,
    required Animation<double> fade,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // ✅ Animated AppBar (no change in AppBar UI)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _animatedEntry(
          slide: _appBarSlide,
          fade: _appBarFade,
          child: AppBar(
            title: const Text('AI Nutrition Insights'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    _messages.clear();
                  });
                  _initializeChat();
                },
                tooltip: 'Start new conversation',
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ✅ Messages list / empty state animated from bottom
            Expanded(
              child: _animatedEntry(
                slide: _contentSlide,
                fade: _contentFade,
                child: _messages.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.3,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Start a conversation',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return ChatMessageBubbleWidget(
                      message: _messages[index],
                    );
                  },
                ),
              ),
            ),

            // Loading indicator (same UI, no animation change needed)
            if (_isLoading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'AI is thinking...',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // ✅ Chat input animated from bottom
            _animatedEntry(
              slide: _inputSlide,
              fade: _inputFade,
              child: ChatInputWidget(
                controller: _textController,
                onSend: _sendMessage,
                isEnabled: !_isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}