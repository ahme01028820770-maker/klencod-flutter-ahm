import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Art Studio Pro',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090D16),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B5CF6),
          brightness: Brightness.dark,
        ),
      ),
      home: const ImageGeneratorScreen(),
    );
  }
}

class ImageGeneratorScreen extends StatefulWidget {
  const ImageGeneratorScreen({super.key});

  @override
  State<ImageGeneratorScreen5State> createState() => ImageGeneratorScreen5State();
}

class ImageGeneratorScreen5State extends State<ImageGeneratorScreen> {
  final TextEditingController _promptController = TextEditingController();
  String? _imageUrl;
  bool _isLoading = false;
  String? _errorMessage; // لتسجيل وعرض سبب الخطأ بالتفصيل

  void _generateImage() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) {
      setState(() {
        _errorMessage = "يرجى كتابة وصف الصورة أولاً!";
      });
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _imageUrl = null;
      _errorMessage = null;
    });

    try {
      // ترميز الوصف بشكل احترافي لدعم العربية والإنجليزية
      final encodedPrompt = Uri.encodeComponent(prompt);
      final int randomNumber = Random().nextInt(999999);
      
      // رابط الخدمة مع إعدادات تضمن الاستجابة السريعة
      final url = 'https://image.pollinations.ai/prompt/$encodedPrompt?width=768&height=768&seed=$randomNumber&nologo=true';

      // محاكاة بسيطة للاتصال لمنح الواجهة سلاسة الانتقال
      await Future.delayed(const Duration(milliseconds: 600));

      if (mounted) {
        setState(() {
          _imageUrl = url;
          _isLoading = false;
        });
      }
    } catch (e) {
      // التقاط أي خطأ برمجي أو شبكي وعرض سببه بدقة
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "حدث خطأ أثناء الاتصال: ${e.toString()}";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.auto_awesome, color: Color(0xFFA78BFA), size: 22),
            SizedBox(width: 8),
            Text(
              'AI Vision Studio',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1.2),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // بطاقة الإدخال الفاخرة
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF131C31),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ماذا تريد أن ترسم اليوم؟',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF94A3B8)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _promptController,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'مثلاً: قطة ترتدي نظارة شمسية في الفضاء...',
                        hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF0B1120),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7C3AED).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _generateImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.bolt_rounded, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'توليد الصورة بالذكاء الاصطناعي',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // منطقة عرض الصورة الناتجة أو رسالة الخطأ المفصلة
              Container(
                height: 380,
                decoration: BoxDecoration(
                  color: const Color(0xFF131C31),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _errorMessage != null 
                        ? Colors.redAccent.withOpacity(0.5) 
                        : const Color(0xFF1E293B),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: _imageUrl == null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _errorMessage != null ? Icons.error_outline_rounded : Icons.image_outlined,
                                  size: 56,
                                  color: _errorMessage != null ? Colors.redAccent : Colors.grey.shade600,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _errorMessage ?? 'ستظهر اللوحة الفنية الخاصة بك هنا',
                                  style: TextStyle(
                                    color: _errorMessage != null ? Colors.redAccent : Colors.grey.shade400,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                if (_errorMessage != null) ...[
                                  const SizedBox(height: 8),
                                  const Text(
                                    'السبب المحتمل: قد يكون بسبب انقطاع الانترنت، أو ضغط على السيرفر، أو وصف غير مدعوم.',
                                    style: TextStyle(color: Colors.grey, fontSize: 11),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        )
                      : Image.network(
                          _imageUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                color: const Color(0xFFA78BFA),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            // إظهار سبب فشل التحميل بدقة على الشاشة للمستخدم
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.wifi_off_rounded, size: 50, color: Colors.orangeAccent),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'فشل تحميل الصورة من الخادم!',
                                      style: TextStyle(color: Colors.orangeAccent, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'التفاصيل: فشل جلب البيانات (رابط الاستجابة غير متوفر أو مهلة الاتصال انتهت). جرب كتابة الوصف باللغة الإنجليزية وتأكد من اتصالك بالإنترنت.',
                                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
