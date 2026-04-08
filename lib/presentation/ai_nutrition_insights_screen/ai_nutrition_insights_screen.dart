// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:naijafit/presentation/ai_nutrition_insights_screen/widgets/chat_message_bubble_widget.dart';
// import 'package:naijafit/widgets/custom_backbutton.dart';
// import 'package:sizer/sizer.dart';
// import '../../../models/chat_message_model.dart';
// import '../../../services/auth_service.dart';
// import '../../../services/openai_service.dart';
//
// class AiNutritionChatScreen extends StatefulWidget {
//   /// [autoStartChat] = true hone par:
//   /// → User ki taraf se koi message NAHI jata
//   /// → Seedha AI ki taraf se automatic welcome message aata hai
//   final bool autoStartChat;
//
//   const AiNutritionChatScreen({
//     super.key,
//     this.autoStartChat = false,
//   });
//
//   @override
//   State<AiNutritionChatScreen> createState() =>
//       _AiNutritionChatScreenState();
// }
//
// class _AiNutritionChatScreenState extends State<AiNutritionChatScreen>
//     with SingleTickerProviderStateMixin {
//   final List<ChatMessageModel> _messages = [];
//   final ScrollController _scrollController = ScrollController();
//   final TextEditingController _textController = TextEditingController();
//   bool _isLoading = false;
//   String? _userGoal;
//
//   // ── Animations ──
//   late final AnimationController _controller;
//
//   late final Animation<Offset> _headerSlide;
//   late final Animation<double> _headerFade;
//
//   late final Animation<Offset> _contentSlide;
//   late final Animation<double> _contentFade;
//
//   late final Animation<Offset> _inputSlide;
//   late final Animation<double> _inputFade;
//
//   final ImagePicker _imagePicker = ImagePicker();
//
//   @override
//   void initState() {
//     super.initState();
//     _setupAnimations();
//     _initializeChat();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) _controller.forward();
//     });
//   }
//
//   void _setupAnimations() {
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1100),
//     );
//
//     // Header – upar se neeche
//     _headerSlide = Tween<Offset>(
//       begin: const Offset(0, -0.35),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.00, 0.20, curve: Curves.easeOutCubic),
//     ));
//     _headerFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.00, 0.20, curve: Curves.easeOut),
//     ));
//
//     // Content – neeche se upar
//     _contentSlide = Tween<Offset>(
//       begin: const Offset(0, 0.35),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.18, 0.88, curve: Curves.easeOutCubic),
//     ));
//     _contentFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.18, 0.80, curve: Curves.easeOut),
//     ));
//
//     // Input – neeche se upar
//     _inputSlide = Tween<Offset>(
//       begin: const Offset(0, 0.40),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.60, 1.00, curve: Curves.easeOutCubic),
//     ));
//     _inputFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.60, 1.00, curve: Curves.easeOut),
//     ));
//   }
//
//   /// ─────────────────────────────────────────────────────────
//   /// Chat initialize:
//   ///
//   /// autoStartChat = true (Say Hello! button se aaya):
//   ///   → User ka koi message list mein NAHI dikhta
//   ///   → Seedha AI ka greeting API se fetch hota hai
//   ///   → AI ka response list mein pehla message ban ke aata hai
//   ///
//   /// autoStartChat = false (normal open):
//   ///   → Hardcoded AI welcome message dikhta hai (API call nahi)
//   /// ─────────────────────────────────────────────────────────
//   Future<void> _initializeChat() async {
//     try {
//       final user = AuthService.instance.currentUser;
//       if (user != null) {
//         final profile = await AuthService.instance.getUserProfile(user.id);
//         _userGoal = profile?.fitnessGoal;
//       }
//     } catch (e) {
//       debugPrint('Profile load error: $e');
//     }
//
//     if (widget.autoStartChat) {
//       // ── AI ki taraf se automatic greeting fetch karo ──
//       // User ka message list mein bilkul nahi dikhega
//       setState(() {
//         _isLoading = true;
//       });
//
//       try {
//         final apiMessages = [
//           ChatMessage(
//             role: 'system',
//             content: OpenAIService.instance.getSystemPrompt(_userGoal),
//           ),
//           // AI ko greet karne ke liye hidden prompt
//           ChatMessage(
//             role: 'user',
//             content:
//             'Please introduce yourself as a Nigerian Nutrition AI Coach and greet the user warmly. Keep it short and friendly.',
//           ),
//         ];
//
//         final response = await OpenAIService.instance.sendChatMessage(
//           messages: apiMessages,
//         );
//
//         if (mounted) {
//           setState(() {
//             _messages.add(
//               ChatMessageModel(
//                 id: DateTime.now().millisecondsSinceEpoch.toString(),
//                 role: 'assistant',
//                 content: response,
//                 timestamp: DateTime.now(),
//               ),
//             );
//             _isLoading = false;
//           });
//           _scrollToBottom();
//         }
//       } catch (e) {
//         // API fail hone par fallback hardcoded message
//         if (mounted) {
//           setState(() {
//             _messages.add(
//               ChatMessageModel(
//                 id: DateTime.now().millisecondsSinceEpoch.toString(),
//                 role: 'assistant',
//                 content:
//                 "Hello! I'm your Nigerian Nutrition AI Coach. I can help you with meal planning, calorie tracking, and healthy Nigerian food choices. What would you like to know?",
//                 timestamp: DateTime.now(),
//               ),
//             );
//             _isLoading = false;
//           });
//           _scrollToBottom();
//         }
//       }
//     } else {
//       // ── Normal open: hardcoded welcome message ──
//       setState(() {
//         _messages.add(
//           ChatMessageModel(
//             id: DateTime.now().millisecondsSinceEpoch.toString(),
//             role: 'assistant',
//             content:
//             "Hello! I'm your Nigerian Nutrition AI Coach. I can help you with meal planning, calorie tracking, and healthy Nigerian food choices. What would you like to know?",
//             timestamp: DateTime.now(),
//           ),
//         );
//       });
//     }
//   }
//
//   Future<void> _sendMessage(String text) async {
//     if (text.trim().isEmpty) return;
//
//     final userMessage = ChatMessageModel(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       role: 'user',
//       content: text.trim(),
//       timestamp: DateTime.now(),
//     );
//
//     setState(() {
//       _messages.add(userMessage);
//       _isLoading = true;
//     });
//
//     _textController.clear();
//     _scrollToBottom();
//
//     try {
//       final apiMessages = [
//         ChatMessage(
//           role: 'system',
//           content: OpenAIService.instance.getSystemPrompt(_userGoal),
//         ),
//         ..._messages
//             .where((m) => !m.isError)
//             .map((m) => ChatMessage(role: m.role, content: m.content)),
//       ];
//
//       final response = await OpenAIService.instance.sendChatMessage(
//         messages: apiMessages,
//       );
//
//       final assistantMessage = ChatMessageModel(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         role: 'assistant',
//         content: response,
//         timestamp: DateTime.now(),
//       );
//
//       setState(() {
//         _messages.add(assistantMessage);
//         _isLoading = false;
//       });
//
//       _scrollToBottom();
//     } catch (e) {
//       setState(() {
//         _messages.add(
//           ChatMessageModel(
//             id: DateTime.now().millisecondsSinceEpoch.toString(),
//             role: 'assistant',
//             content:
//             "Sorry, I couldn't process your request. Please try again.",
//             timestamp: DateTime.now(),
//             isError: true,
//           ),
//         );
//         _isLoading = false;
//       });
//       _scrollToBottom();
//     }
//   }
//
//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   // ── Plus button → Gallery directly ──
//   Future<void> _openGallery() async {
//     try {
//       final XFile? image = await _imagePicker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 80,
//       );
//       if (image != null && mounted) {
//         debugPrint('Gallery image selected: ${image.path}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Image selected: ${image.name}',
//               style: const TextStyle(fontFamily: "semibold"),
//             ),
//             backgroundColor: Theme.of(context).colorScheme.primary,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     } catch (e) {
//       debugPrint('Gallery error: $e');
//     }
//   }
//
//   // ── Attachment icon → WhatsApp style bottom sheet ──
//   void _showAttachmentSheet() {
//     final theme = Theme.of(context);
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (ctx) {
//         return Container(
//           margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
//           decoration: BoxDecoration(
//             color: theme.colorScheme.surface,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Handle bar
//                   Container(
//                     width: 40,
//                     height: 4,
//                     margin: EdgeInsets.only(bottom: 2.h),
//                     decoration: BoxDecoration(
//                       color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                   // Options grid
//                   GridView.count(
//                     shrinkWrap: true,
//                     crossAxisCount: 4,
//                     crossAxisSpacing: 2.w,
//                     mainAxisSpacing: 2.h,
//                     childAspectRatio: 0.85,
//                     physics: const NeverScrollableScrollPhysics(),
//                     children: [
//                       _attachItem(
//                         context: ctx,
//                         icon: Icons.insert_drive_file_rounded,
//                         label: 'Document',
//                         color: const Color(0xFF5B8DEF),
//                         onTap: () async {
//                           Navigator.pop(ctx);
//                           await _pickDocument();
//                         },
//                       ),
//                       _attachItem(
//                         context: ctx,
//                         icon: Icons.camera_alt_rounded,
//                         label: 'Camera',
//                         color: const Color(0xFFFF6B6B),
//                         onTap: () async {
//                           Navigator.pop(ctx);
//                           await _openCamera();
//                         },
//                       ),
//                       _attachItem(
//                         context: ctx,
//                         icon: Icons.photo_library_rounded,
//                         label: 'Gallery',
//                         color: const Color(0xFFAF52DE),
//                         onTap: () async {
//                           Navigator.pop(ctx);
//                           await _openGallery();
//                         },
//                       ),
//                       _attachItem(
//                         context: ctx,
//                         icon: Icons.contacts_rounded,
//                         label: 'Contact',
//                         color: const Color(0xFF34C759),
//                         onTap: () {
//                           Navigator.pop(ctx);
//                           _shareContact();
//                         },
//                       ),
//                       _attachItem(
//                         context: ctx,
//                         icon: Icons.headphones_rounded,
//                         label: 'Audio',
//                         color: const Color(0xFFFF9500),
//                         onTap: () async {
//                           Navigator.pop(ctx);
//                           await _pickAudio();
//                         },
//                       ),
//                       _attachItem(
//                         context: ctx,
//                         icon: Icons.poll_rounded,
//                         label: 'Poll',
//                         color: const Color(0xFF00C7BE),
//                         onTap: () {
//                           Navigator.pop(ctx);
//                           _createPoll();
//                         },
//                       ),
//                       _attachItem(
//                         context: ctx,
//                         icon: Icons.event_rounded,
//                         label: 'Event',
//                         color: const Color(0xFFFF2D55),
//                         onTap: () {
//                           Navigator.pop(ctx);
//                           _createEvent();
//                         },
//                       ),
//                       _attachItem(
//                         context: ctx,
//                         icon: Icons.auto_awesome_rounded,
//                         label: 'AI Image',
//                         color: const Color(0xFF5856D6),
//                         onTap: () {
//                           Navigator.pop(ctx);
//                           _generateAiImage();
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 1.h),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _attachItem({
//     required BuildContext context,
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     final theme = Theme.of(context);
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 56,
//             height: 56,
//             decoration: BoxDecoration(
//               color: color.withValues(alpha: 0.12),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: color, size: 26),
//           ),
//           SizedBox(height: 0.6.h),
//           Text(
//             label,
//             style: TextStyle(
//               fontFamily: "bold",
//               fontSize: 9.sp,
//               color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Attachment action functions ──
//
//   Future<void> _pickDocument() async {
//     try {
//       final FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'xls', 'xlsx'],
//       );
//       if (result != null && mounted) {
//         final PlatformFile file = result.files.first;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Document: ${file.name}',
//               style: const TextStyle(fontFamily: "bold"),
//             ),
//             backgroundColor: Theme.of(context).colorScheme.primary,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     } catch (e) {
//       debugPrint('Document picker error: $e');
//     }
//   }
//
//   Future<void> _openCamera() async {
//     try {
//       final XFile? photo = await _imagePicker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 80,
//       );
//       if (photo != null && mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text(
//               'Photo captured!',
//               style: TextStyle(fontFamily: "bold"),
//             ),
//             backgroundColor: Theme.of(context).colorScheme.primary,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     } catch (e) {
//       debugPrint('Camera error: $e');
//     }
//   }
//
//   void _shareContact() {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text(
//             'Contact sharing coming soon!',
//             style: TextStyle(fontFamily: "bold"),
//           ),
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }
//
//   Future<void> _pickAudio() async {
//     try {
//       final FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.audio,
//       );
//       if (result != null && mounted) {
//         final PlatformFile file = result.files.first;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Audio: ${file.name}',
//               style: const TextStyle(fontFamily: "bold"),
//             ),
//             backgroundColor: Theme.of(context).colorScheme.primary,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     } catch (e) {
//       debugPrint('Audio error: $e');
//     }
//   }
//
//   void _createPoll() {
//     final theme = Theme.of(context);
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           'Create Pol',
//           style: TextStyle(
//             fontFamily: "bold",
//             color: theme.colorScheme.primary,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         content: const Text(
//           'Poll feature coming soon!',
//           style: TextStyle(fontFamily: "semibold"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'OK',
//               style: TextStyle(
//                 fontFamily: "bold",
//                 color: theme.colorScheme.primary,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _createEvent() {
//     final theme = Theme.of(context);
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           'Create Event',
//           style: TextStyle(
//             fontFamily: "bold",
//             color: theme.colorScheme.primary,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         content: const Text(
//           'Event scheduling coming soon!',
//           style: TextStyle(fontFamily: "semibold"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'OK',
//               style: TextStyle(
//                 fontFamily: "bold",
//                 color: theme.colorScheme.primary,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _generateAiImage() {
//     final theme = Theme.of(context);
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           'AI Image',
//           style: TextStyle(
//             fontFamily: "bold",
//             color: theme.colorScheme.primary,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         content: const Text(
//           'AI image generation coming soon!',
//           style: TextStyle(fontFamily: "semibold"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'OK',
//               style: TextStyle(
//                 fontFamily: "bold",
//                 color: theme.colorScheme.primary,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _animatedEntry({
//     required Animation<Offset> slide,
//     required Animation<double> fade,
//     required Widget child,
//   }) {
//     return FadeTransition(
//       opacity: fade,
//       child: SlideTransition(position: slide, child: child),
//     );
//   }
//
//   // ══════════════════════════════════════════════════
//   // AI AVATAR WIDGET
//   // Circle shape mein image — baad mein asset change kar lena
//   // ══════════════════════════════════════════════════
//   Widget _aiAvatar(ThemeData theme) {
//     return ClipOval(
//       child: Image.asset(
//         // ✅ Yahan apni AI coach image ka path daalo
//         'assets/images/aiprofile.png',
//         width: 32,
//         height: 32,
//         fit: BoxFit.cover,
//         errorBuilder: (_, __, ___) => Container(
//           width: 32,
//           height: 32,
//           decoration: BoxDecoration(
//             color: theme.colorScheme.primary,
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             Icons.smart_toy,
//             size: 18,
//             color: theme.colorScheme.onPrimary,
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _scrollController.dispose();
//     _textController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       // ── NO AppBar — header body ke andar hai ──
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ════════════════════════════════════════
//             // HEADER – body ke andar, scroll view ke bahar
//             // Back button (left) + Logo (right)
//             // ════════════════════════════════════════
//             _animatedEntry(
//               slide: _headerSlide,
//               fade: _headerFade,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 4.w,
//                   vertical: 2.h,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Back button
//                     CustomBackButton(onTap: () => Navigator.pop(context)),
//
//                     // Logo
//                     Image.asset(
//                       'assets/images/LOGO.png',
//                       width: 60,
//                       height: 60,
//                       errorBuilder: (_, __, ___) => Container(
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                           color:
//                           theme.colorScheme.primary.withValues(alpha: 0.1),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           Icons.restaurant,
//                           color: theme.colorScheme.primary,
//                           size: 28,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // ════════════════════════════════════════
//             // MESSAGES LIST
//             // ════════════════════════════════════════
//             Expanded(
//               child: _animatedEntry(
//                 slide: _contentSlide,
//                 fade: _contentFade,
//                 child: _messages.isEmpty && !_isLoading
//                     ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.chat_bubble_outline,
//                         size: 64,
//                         color: theme.colorScheme.primary
//                             .withValues(alpha: 0.3),
//                       ),
//                       SizedBox(height: 2.h),
//                       Text(
//                         'Start a conversation',
//                         style: theme.textTheme.titleMedium?.copyWith(
//                           fontFamily: "bold",
//                           color: theme.colorScheme.onSurface
//                               .withValues(alpha: 0.6),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//                     : ListView.builder(
//                   controller: _scrollController,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 4.w,
//                     vertical: 2.h,
//                   ),
//                   itemCount: _messages.length,
//                   itemBuilder: (context, index) {
//                     final message = _messages[index];
//                     final isUser = message.isUser;
//
//                     // ── User message: original ChatMessageBubbleWidget ──
//                     if (isUser) {
//                       return ChatMessageBubbleWidget(message: message);
//                     }
//
//                     // ── AI message: custom row with avatar image ──
//                     return Padding(
//                       padding: EdgeInsets.only(bottom: 1.5.h),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           // ── AI Avatar circle image ──
//                           _aiAvatar(theme),
//
//                           SizedBox(width: 2.w),
//
//                           // ── AI message bubble ──
//                           Flexible(
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 4.w,
//                                 vertical: 1.5.h,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: message.isError
//                                     ? theme.colorScheme.error
//                                     .withValues(alpha: 0.1)
//                                     : theme.colorScheme
//                                     .surfaceContainerHighest,
//                                 borderRadius: const BorderRadius.only(
//                                   topLeft: Radius.circular(16),
//                                   topRight: Radius.circular(16),
//                                   bottomLeft: Radius.circular(4),
//                                   bottomRight: Radius.circular(16),
//                                 ),
//                               ),
//                               child: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     message.content,
//                                     style: theme.textTheme.bodyMedium
//                                         ?.copyWith(
//                                       fontFamily: "regular",
//                                       color: message.isError
//                                           ? theme.colorScheme.error
//                                           : theme.colorScheme.onSurface,
//                                       height: 1.4,
//                                     ),
//                                   ),
//                                   SizedBox(height: 0.5.h),
//                                   Text(
//                                     _formatTime(message.timestamp),
//                                     style: theme.textTheme.bodySmall
//                                         ?.copyWith(
//                                       fontFamily: "medium",
//                                       color: theme.colorScheme.onSurface
//                                           .withValues(alpha: 0.5),
//                                       fontSize: 10.sp,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//
//             // ── Loading Indicator ──
//             if (_isLoading)
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 1.h),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           theme.colorScheme.primary,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 2.w),
//                     Text(
//                       'AI is thinking...',
//                       style: theme.textTheme.bodySmall?.copyWith(
//                         fontFamily: "medium",
//                         color:
//                         theme.colorScheme.onSurface.withValues(alpha: 0.6),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//             // ════════════════════════════════════════
//             // BOTTOM INPUT BAR
//             // Light green bg (opacity 0.10)
//             // [+]  [TextField  📎]  [➤]
//             // ════════════════════════════════════════
//             _animatedEntry(
//               slide: _inputSlide,
//               fade: _inputFade,
//               child: Container(
//                 padding: EdgeInsets.only(top: 1.5.h,bottom: 4.h,right: 2.h,left: 2.h),
//                 decoration: BoxDecoration(
//                   color: theme.colorScheme.primary.withValues(alpha: 0.10),
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // ── [+] Plus → Gallery ──
//                     GestureDetector(
//                       onTap: _openGallery,
//                       child: Icon(
//                         Icons.add,
//                         color: theme.colorScheme.primary,
//                         size: 28,
//                       ),
//                     ),
//
//                     SizedBox(width: 3.w),
//
//                     // ── TextField with 📎 inside ──
//                     Expanded(
//                       child: Container(
//                         height: 36,
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 3.w, vertical: 0),
//                         decoration: BoxDecoration(
//                           color: theme.colorScheme.surface,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               child: TextField(
//                                 controller: _textController,
//                                 enabled: !_isLoading,
//                                 maxLines: null,
//                                 textInputAction: TextInputAction.send,
//                                 onSubmitted:
//                                 !_isLoading ? _sendMessage : null,
//                                 style: theme.textTheme.bodyMedium?.copyWith(
//                                   fontFamily: "regular",
//                                 ),
//                                 decoration: InputDecoration(
//                                   hintText: 'Search...',
//                                   hintStyle:
//                                   theme.textTheme.bodyMedium?.copyWith(
//                                     fontFamily: "regular",
//                                     color: theme.colorScheme.onSurface
//                                         .withValues(alpha: 0.4),
//                                   ),
//                                   border: InputBorder.none,
//                                   enabledBorder: InputBorder.none,
//                                   focusedBorder: InputBorder.none,
//                                   isDense: true,
//                                   contentPadding: EdgeInsets.symmetric(
//                                     vertical: 1.2.h,
//                                   ),
//                                 ),
//                               ),
//                             ),
//
//                             // ── 📎 Attachment icon (right inside textfield) ──
//                             GestureDetector(
//                               onTap: _showAttachmentSheet,
//                               child: Padding(
//                                 padding: EdgeInsets.only(right: 1.w),
//                                 child: Icon(
//                                   Icons.attach_file_rounded,
//                                   color: theme.colorScheme.primary,
//                                   size: 22,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     SizedBox(width: 3.w),
//
//                     // ── Send ➤ (no background, no container) ──
//                     GestureDetector(
//                       onTap: !_isLoading
//                           ? () {
//                         if (_textController.text.trim().isNotEmpty) {
//                           _sendMessage(_textController.text);
//                         }
//                       }
//                           : null,
//                       child: Icon(
//                         Icons.send_rounded,
//                         color: !_isLoading
//                             ? theme.colorScheme.primary
//                             : theme.colorScheme.onSurface
//                             .withValues(alpha: 0.3),
//                         size: 28,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _formatTime(DateTime timestamp) {
//     final now = DateTime.now();
//     final difference = now.difference(timestamp);
//     if (difference.inMinutes < 1) return 'Just now';
//     if (difference.inHours < 1) return '${difference.inMinutes}m ago';
//     if (difference.inDays < 1) return '${difference.inHours}h ago';
//     return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
//   }
// }




















import 'package:flutter/material.dart';
import 'package:naijafit/widgets/custom_backbutton.dart';
import 'package:sizer/sizer.dart';

class AiNutritionChatScreen extends StatefulWidget {
  final bool autoStartChat;

  const AiNutritionChatScreen({
    super.key,
    this.autoStartChat = false,
  });

  @override
  State<AiNutritionChatScreen> createState() => _AiNutritionChatScreenState();
}

class _AiNutritionChatScreenState extends State<AiNutritionChatScreen>
    with SingleTickerProviderStateMixin {
  // ── Animations ──
  late final AnimationController _controller;

  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerFade;

  late final Animation<Offset> _contentSlide;
  late final Animation<double> _contentFade;

  late final Animation<Offset> _inputSlide;
  late final Animation<double> _inputFade;

  @override
  void initState() {
    super.initState();
    _setupAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.20, curve: Curves.easeOutCubic),
      ),
    );

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.20, curve: Curves.easeOut),
      ),
    );

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

  Widget _aiAvatar(ThemeData theme) {
    return ClipOval(
      child: Image.asset(
        'assets/images/aiprofile.png',
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.smart_toy_rounded,
            size: 34,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  void _showPremiumAccessMessage() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 3.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12.w,
                  height: 0.6.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                SizedBox(height: 2.2.h),
                Container(
                  width: 18.w,
                  height: 18.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F4EA),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    size: 34,
                    color: Color(0xFF1B7F3A),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'AI Nutrition Coach is a premium feature',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: "bold",
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Unlock the full features of NaijaFit to chat with your AI coach, get personalized food insights, and receive nutrition guidance.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: "regular",
                    height: 1.5,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.70),
                  ),
                ),
                SizedBox(height: 2.5.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);

                      // TODO: Replace with your actual paywall / Plan Screen 1 route
                      // Navigator.pushNamed(context, AppRoutes.planScreenOne);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Redirect user to Plan Screen 1 / Paywall',
                            style: TextStyle(fontFamily: "semibold"),
                          ),
                          backgroundColor: theme.colorScheme.primary,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B7F3A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 1.7.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Unlock Premium',
                      style: TextStyle(
                        fontFamily: "bold",
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Maybe later',
                    style: TextStyle(
                      fontFamily: "medium",
                      fontSize: 11.sp,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLockedChatPreview(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        children: [
          _previewBubble(
            theme: theme,
            isAi: true,
            text:
            "Hello! I'm your Nigerian Nutrition AI Coach. I can help you with meal planning and healthy Nigerian food choices.",
          ),
          SizedBox(height: 1.3.h),
          _previewBubble(
            theme: theme,
            isAi: false,
            text: "How can I reduce calories in jollof rice?",
          ),
          SizedBox(height: 1.3.h),
          _previewBubble(
            theme: theme,
            isAi: true,
            text:
            "Unlock premium to chat with your AI Coach and get personalized nutrition guidance.",
          ),
        ],
      ),
    );
  }

  Widget _previewBubble({
    required ThemeData theme,
    required bool isAi,
    required String text,
  }) {
    return Row(
      mainAxisAlignment:
      isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isAi) ...[
          _aiAvatar(theme),
          SizedBox(width: 2.5.w),
        ],
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: isAi
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isAi ? 4 : 16),
                bottomRight: Radius.circular(isAi ? 16 : 4),
              ),
            ),
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: "regular",
                color: theme.colorScheme.onSurface,
                height: 1.45,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLockedStateCard(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 18.w,
            height: 18.w,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F4EA),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 34,
              color: Color(0xFF1B7F3A),
            ),
          ),
          SizedBox(height: 1.8.h),
          Text(
            'Premium feature locked',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontFamily: "bold",
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your AI Nutrition Coach is available after subscription. Upgrade to unlock personalized nutrition support and smarter meal guidance.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: "regular",
              height: 1.55,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          SizedBox(height: 2.3.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showPremiumAccessMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B7F3A),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 1.6.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Unlock the full features of NaijaFit',
                style: TextStyle(
                  fontFamily: "bold",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledInputBar(ThemeData theme) {
    return Container(
      padding: EdgeInsets.only(top: 1.5.h, bottom: 4.h, right: 2.h, left: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.add,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.30),
            size: 28,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: GestureDetector(
              onTap: _showPremiumAccessMessage,
              child: Container(
                height: 44,
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Unlock premium to chat...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontFamily: "regular",
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.42),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.attach_file_rounded,
                      color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.28),
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          GestureDetector(
            onTap: _showPremiumAccessMessage,
            child: Icon(
              Icons.send_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.30),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _animatedEntry(
              slide: _headerSlide,
              fade: _headerFade,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBackButton(onTap: () => Navigator.pop(context)),
                    Text(
                      'AI Nutrition Coach',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontFamily: "bold",
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Image.asset(
                      'assets/images/LOGO.png',
                      width: 60,
                      height: 60,
                      errorBuilder: (_, __, ___) => Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color:
                          theme.colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.restaurant,
                          color: theme.colorScheme.primary,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: _animatedEntry(
                slide: _contentSlide,
                fade: _contentFade,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: Column(
                    children: [
                      SizedBox(height: 1.h),
                      _buildLockedChatPreview(theme),
                      SizedBox(height: 2.h),
                      _buildLockedStateCard(theme),
                    ],
                  ),
                ),
              ),
            ),

            _animatedEntry(
              slide: _inputSlide,
              fade: _inputFade,
              child: _buildDisabledInputBar(theme),
            ),
          ],
        ),
      ),
    );
  }
}
















// ── Old code preserved (do not remove) ──

// import 'package:flutter/material.dart';
// import 'package:naijafit/presentation/ai_nutrition_insights_screen/widgets/chat_input_widget.dart';
// import 'package:naijafit/presentation/ai_nutrition_insights_screen/widgets/chat_message_bubble_widget.dart';
// import 'package:naijafit/widgets/custom_backbutton.dart';
// import 'package:sizer/sizer.dart';
// import '../../../models/chat_message_model.dart';
// import '../../../services/auth_service.dart';
// import '../../../services/openai_service.dart';
//
// class AiNutritionChatScreen extends StatefulWidget {
//   final bool autoStartChat;
//   const AiNutritionChatScreen({super.key, this.autoStartChat = false});
//   @override
//   State<AiNutritionChatScreen> createState() => _AiNutritionChatScreenState();
// }
//
// class _AiNutritionChatScreenState extends State<AiNutritionChatScreen>
//     with SingleTickerProviderStateMixin {
//   final List<ChatMessageModel> _messages = [];
//   final ScrollController _scrollController = ScrollController();
//   final TextEditingController _textController = TextEditingController();
//   bool _isLoading = false;
//   String? _userGoal;
//   late final AnimationController _controller;
//   late final Animation<Offset> _appBarSlide;
//   late final Animation<double> _appBarFade;
//   late final Animation<Offset> _contentSlide;
//   late final Animation<double> _contentFade;
//   late final Animation<Offset> _inputSlide;
//   late final Animation<double> _inputFade;
//
//   @override
//   void initState() {
//     super.initState();
//     _setupAnimations();
//     _initializeChat();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) _controller.forward();
//     });
//   }
//
//   void _setupAnimations() {
//     _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));
//     _appBarSlide = Tween<Offset>(begin: const Offset(0, -0.35), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.00, 0.20, curve: Curves.easeOutCubic)));
//     _appBarFade = Tween<double>(begin: 0, end: 1)
//         .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.00, 0.20, curve: Curves.easeOut)));
//     _contentSlide = Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.18, 0.88, curve: Curves.easeOutCubic)));
//     _contentFade = Tween<double>(begin: 0, end: 1)
//         .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.18, 0.80, curve: Curves.easeOut)));
//     _inputSlide = Tween<Offset>(begin: const Offset(0, 0.40), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.60, 1.00, curve: Curves.easeOutCubic)));
//     _inputFade = Tween<double>(begin: 0, end: 1)
//         .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.60, 1.00, curve: Curves.easeOut)));
//   }
//
//   Future<void> _initializeChat() async {
//     try {
//       final user = AuthService.instance.currentUser;
//       if (user != null) {
//         final profile = await AuthService.instance.getUserProfile(user.id);
//         _userGoal = profile?.fitnessGoal;
//       }
//     } catch (e) { debugPrint('Profile load error: $e'); }
//     if (widget.autoStartChat) {
//       await _sendMessage('Say Hello!');
//     } else {
//       setState(() {
//         _messages.add(ChatMessageModel(
//           id: DateTime.now().millisecondsSinceEpoch.toString(),
//           role: 'assistant',
//           content: "Hello! I'm your Nigerian Nutrition AI Coach. I can help you with meal planning, calorie tracking, and healthy Nigerian food choices. What would you like to know?",
//           timestamp: DateTime.now(),
//         ));
//       });
//     }
//   }
//
//   Future<void> _sendMessage(String text) async {
//     if (text.trim().isEmpty) return;
//     final userMessage = ChatMessageModel(id: DateTime.now().millisecondsSinceEpoch.toString(), role: 'user', content: text.trim(), timestamp: DateTime.now());
//     setState(() { _messages.add(userMessage); _isLoading = true; });
//     _textController.clear();
//     _scrollToBottom();
//     try {
//       final apiMessages = [
//         ChatMessage(role: 'system', content: OpenAIService.instance.getSystemPrompt(_userGoal)),
//         ..._messages.where((m) => !m.isError).map((m) => ChatMessage(role: m.role, content: m.content)),
//       ];
//       final response = await OpenAIService.instance.sendChatMessage(messages: apiMessages);
//       setState(() { _messages.add(ChatMessageModel(id: DateTime.now().millisecondsSinceEpoch.toString(), role: 'assistant', content: response, timestamp: DateTime.now())); _isLoading = false; });
//       _scrollToBottom();
//     } catch (e) {
//       setState(() { _messages.add(ChatMessageModel(id: DateTime.now().millisecondsSinceEpoch.toString(), role: 'assistant', content: "Sorry, I couldn't process your request. Please try again.", timestamp: DateTime.now(), isError: true)); _isLoading = false; });
//       _scrollToBottom();
//     }
//   }
//
//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) { _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut); }
//     });
//   }
//
//   Widget _animatedEntry({required Animation<Offset> slide, required Animation<double> fade, required Widget child}) {
//     return FadeTransition(opacity: fade, child: SlideTransition(position: slide, child: child));
//   }
//
//   @override
//   void dispose() { _controller.dispose(); _scrollController.dispose(); _textController.dispose(); super.dispose(); }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(kToolbarHeight),
//         child: _animatedEntry(
//           slide: _appBarSlide, fade: _appBarFade,
//           child: AppBar(
//             leading: CustomBackButton(onTap: () { Navigator.pop(context); }),
//             actions: [
//               Padding(
//                 padding: EdgeInsets.only(right: 4.w),
//                 child: Image.asset('assets/images/LOGO.png', width: 60, height: 60,
//                   errorBuilder: (_, __, ___) => Container(width: 60, height: 60, decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(Icons.restaurant, color: theme.colorScheme.primary, size: 22)),
//                 ),
//               ),
//             ],
//             backgroundColor: theme.scaffoldBackgroundColor,
//             elevation: 0, scrolledUnderElevation: 0,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(child: _animatedEntry(slide: _contentSlide, fade: _contentFade, child: _messages.isEmpty
//               ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.chat_bubble_outline, size: 64, color: theme.colorScheme.primary.withValues(alpha: 0.3)), SizedBox(height: 2.h), Text('Start a conversation', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)))]))
//               : ListView.builder(controller: _scrollController, padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h), itemCount: _messages.length, itemBuilder: (context, index) => ChatMessageBubbleWidget(message: _messages[index])))),
//             if (_isLoading) Padding(padding: EdgeInsets.symmetric(vertical: 1.h), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary))), SizedBox(width: 2.w), Text('AI is thinking...', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)))])),
//             _animatedEntry(slide: _inputSlide, fade: _inputFade, child: ChatInputWidget(controller: _textController, onSend: _sendMessage, isEnabled: !_isLoading)),
//           ],
//         ),
//       ),
//     );
//   }
// }
