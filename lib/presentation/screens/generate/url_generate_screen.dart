import 'package:flutter/material.dart';
import 'package:sqs_mobile/data/models/generated.dart';
import 'package:sqs_mobile/data/repositories/generated_repository.dart';
import 'package:sqs_mobile/presentation/screens/result/text_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/result/url_result_screen.dart';
import 'package:sqs_mobile/presentation/widgets/default_button.dart';
import 'package:sqs_mobile/presentation/widgets/default_header.dart';
import 'package:sqs_mobile/presentation/widgets/text_field.dart';
import 'package:sqs_mobile/theme/app_colors.dart';
import 'package:sqs_mobile/utils/validate_helper.dart';

class UrlGenerateScreen extends StatefulWidget {
  final GeneratedModel? data;
  const UrlGenerateScreen({super.key, required this.data});

  @override
  State<UrlGenerateScreen> createState() => _UrlGenerateScreenState();
}

class _UrlGenerateScreenState extends State<UrlGenerateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();
  final GeneratedRepository _generatedRepository = GeneratedRepository();

  late ValueNotifier<bool> isInputValid;
  late int id;

  @override
  void initState() {
    super.initState();
    textController.text = widget.data?.content ?? '';
    id = widget.data?.id ?? 0;
    isInputValid = ValueNotifier(isValidUrl(textController.text));

    textController.addListener(() {
      isInputValid.value = isValidUrl(textController.text);
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final content = textController.text;
    final generatedCode = GeneratedModel(
      id: id != 0 ? id : null,
      content: content,
      type: 'qrcode',
      createAt: DateTime.now(),
      qrType: widget.data?.qrType ?? 'url',
      barcodeType: widget.data?.barcodeType,
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
            (_) => UrlResultScreen(textData: content, isFromHistoryList: false),
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
            Image.asset("assets/icons/generate/url.png", height: 80, width: 80),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: CustomTextField(controller: textController, title: "Url"),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<bool>(
              valueListenable: isInputValid,
              builder: (_, isValid, __) {
                return DefaultButton(
                  title: "Generate QR Code",
                  onPress: _handleSubmit,
                  disabled: !isValid,
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
                        DefaultHeader(title: "Url"),
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
