import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Image Generator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      home: const ImageGeneratorScreen(),
    );
  }
}

class ImageGeneratorScreen extends StatefulWidget {
  const ImageGeneratorScreen({super.key});

  @override
  State<ImageGeneratorScreen> createState() => _ImageGeneratorScreenState();
}

class _ImageGeneratorScreenState extends State<ImageGeneratorScreen> {
  final TextEditingController _promptController = TextEditingController();
  String? _imageUrl;
  bool _isLoading = false;

  void _generateImage() {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    // إخفاء لوحة المفاتيح
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _imageUrl = null;
    });

    // ترميز النص ليدعم اللغة العربية بشكل صحيح في الرابط
    final encodedPrompt = Uri.encodeComponent(prompt);
    final seed = Random().nextInt(999999);
    final url = 'https://image.pollinations.ai/prompt/$encodedPrompt?width=512&height=512&seed=$seed&nologo=true';

    // محاكاة وقت التحميل البسيط لضمان سلاسة الواجهة
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _imageUrl = url;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'مولد الصور بالذكاء الاصطناعي',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // بطاقة الإدخال
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _promptController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'وصف تخيلي لصورة تريد إنشاءها (مثلاً: منظر طبيعي خلاب)...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _generateImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        icon: _isLoading 
                          ? const SizedBox(
                              width: 20, 
                              height: 20, 
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                            )
                          : const Icon(Icons.auto_awesome),
                        label: Text(
                          _isLoading ? 'جاري التوليد...' : 'إنشاء الصورة',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // مكان عرض الصورة
            SizedBox(
              height: 350,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.deepPurple.withOpacity(0.2), width: 1.5),
                  ),
                  child: _imageUrl == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_outlined, size: 64, color: Colors.grey.shade400),
                              const SizedBox(height: 8),
                              Text(
                                'ستظهر الصورة الناتجة هنا',
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                              ),
                            ],
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
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                                  SizedBox(height: 8),
                                  Text('عذراً، فشل تحميل الصورة. جرب وصفاً آخر.', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
