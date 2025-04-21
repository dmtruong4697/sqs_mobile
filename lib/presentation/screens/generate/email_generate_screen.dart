import 'package:flutter/material.dart';
import 'package:sqs_mobile/data/models/generated.dart';
import 'package:sqs_mobile/data/repositories/generated_repository.dart';
import 'package:sqs_mobile/presentation/screens/generate_result/email_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/generate_result/text_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/generate_result/url_result_screen.dart';
import 'package:sqs_mobile/presentation/widgets/default_button.dart';
import 'package:sqs_mobile/presentation/widgets/default_header.dart';
import 'package:sqs_mobile/presentation/widgets/text_field.dart';
import 'package:sqs_mobile/theme/app_colors.dart';
import 'package:sqs_mobile/utils/validate_helper.dart';

class EmailGenerateScreen extends StatefulWidget {
  final GeneratedModel? data;
  const EmailGenerateScreen({super.key, required this.data});

  @override
  State<EmailGenerateScreen> createState() => _EmailGenerateScreenState();
}

class _EmailGenerateScreenState extends State<EmailGenerateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final GeneratedRepository _generatedRepository = GeneratedRepository();

  late ValueNotifier<bool> isInputValid;
  late int id;

  @override
  void initState() {
    super.initState();
    addressController.text =
        parseMatmsg(widget.data?.content ?? '')?['address'] ?? '';
    subjectController.text =
        parseMatmsg(widget.data?.content ?? '')?['subject'] ?? '';
    messageController.text =
        parseMatmsg(widget.data?.content ?? '')?['message'] ?? '';
    id = widget.data?.id ?? 0;
    isInputValid = ValueNotifier(isValidEmail(addressController.text));

    addressController.addListener(() {
      isInputValid.value = isValidEmail(addressController.text);
    });
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  // tach chi tiet email
  Map<String, String>? parseMatmsg(String input) {
    if (!input.startsWith('MATMSG:')) return null;

    final to = RegExp(r'TO:([^;]+);').firstMatch(input)?.group(1);
    final sub = RegExp(r'SUB:([^;]+);').firstMatch(input)?.group(1);
    final body = RegExp(r'BODY:([^;]+);').firstMatch(input)?.group(1);

    if (to == null || sub == null || body == null) return null;

    return {'address': to, 'subject': sub, 'message': body};
  }

  Future<void> _handleSubmit() async {
    final content =
        'MATMSG:TO:${addressController.text};SUB:${subjectController.text};BODY:${messageController.text};';
    final generatedCode = GeneratedModel(
      id: id != 0 ? id : null,
      content: content,
      type: 'qrcode',
      createAt: DateTime.now(),
      qrType: widget.data?.qrType ?? 'email',
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
            (_) =>
                EmailResultScreen(textData: content, isFromHistoryList: false),
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
              "assets/icons/generate/email.png",
              height: 70,
              width: 70,
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: addressController,
                    title: "Email address",
                    keyboardType: TextInputType.emailAddress,
                    placeholder: "example@mail.com",
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: subjectController,
                    title: "Subject",
                    placeholder: "subject",
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: messageController,
                    title: "Message",
                    placeholder: "message",
                  ),
                ],
              ),
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
                        DefaultHeader(title: "Email"),
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
