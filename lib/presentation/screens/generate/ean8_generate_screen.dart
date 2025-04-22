import 'package:flutter/material.dart';
import 'package:sqs_mobile/data/models/generated.dart';
import 'package:sqs_mobile/data/repositories/generated_repository.dart';
import 'package:sqs_mobile/presentation/screens/generate_result/ean8_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/generate_result/text_result_screen.dart';
import 'package:sqs_mobile/presentation/widgets/default_button.dart';
import 'package:sqs_mobile/presentation/widgets/default_header.dart';
import 'package:sqs_mobile/presentation/widgets/text_field.dart';
import 'package:sqs_mobile/theme/app_colors.dart';

class Ean8GenerateScreen extends StatefulWidget {
  final GeneratedModel? data;
  const Ean8GenerateScreen({super.key, required this.data});

  @override
  State<Ean8GenerateScreen> createState() => _Ean8GenerateScreenState();
}

class _Ean8GenerateScreenState extends State<Ean8GenerateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();
  final GeneratedRepository _generatedRepository = GeneratedRepository();

  late ValueNotifier<bool> isTextEmpty;
  late int id;

  @override
  void initState() {
    super.initState();
    textController.text = widget.data?.content ?? '';
    id = widget.data?.id ?? 0;
    isTextEmpty = ValueNotifier(textController.text.isEmpty);

    textController.addListener(() {
      isTextEmpty.value = textController.text.isEmpty;
    });
  }

  @override
  void dispose() {
    textController.dispose();
    isTextEmpty.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final content = textController.text;
    final generatedCode = GeneratedModel(
      id: id != 0 ? id : null,
      content: content,
      type: 'barcode',
      createAt: DateTime.now(),
      qrType: widget.data?.qrType,
      barcodeType: widget.data?.barcodeType ?? 'ean8',
    );

    if (id == 0) {
      id = await _generatedRepository.insert(generatedCode);
    } else {
      await _generatedRepository.update(generatedCode);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) =>
                Ean8ResultScreen(textData: content, isFromHistoryList: false),
      ),
    );
  }

  Widget _buildInputForm() {
    return FractionallySizedBox(
      widthFactor: 0.94,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.symmetric(
            horizontal: BorderSide(width: 5, color: AppColors.primaryDark),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            Image.asset(
              "assets/icons/generate/barcode.png",
              height: 80,
              width: 80,
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: CustomTextField(
                controller: textController,
                title: "Barcode",
                placeholder: "9031101",
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<bool>(
              valueListenable: isTextEmpty,
              builder: (_, disabled, __) {
                return DefaultButton(
                  title: "Generate Barcode",
                  onPress: _handleSubmit,
                  disabled: disabled,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.light,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/background.png",
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        DefaultHeader(title: "Ean 8"),
                        const SizedBox(height: 40),
                        _buildInputForm(),
                      ],
                    ),
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
