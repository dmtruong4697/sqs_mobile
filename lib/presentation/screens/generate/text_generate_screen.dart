import 'package:flutter/material.dart';
import 'package:sqs_mobile/presentation/screens/result/text_result_screen.dart';
import 'package:sqs_mobile/presentation/widgets/default_button.dart';
import 'package:sqs_mobile/presentation/widgets/default_header.dart';
import 'package:sqs_mobile/presentation/widgets/text_field.dart';
import 'package:sqs_mobile/theme/app_colors.dart';

class TextGenerateScreen extends StatefulWidget {
  const TextGenerateScreen({super.key});

  @override
  State<TextGenerateScreen> createState() => _TextGenerateScreenState();
}

class _TextGenerateScreenState extends State<TextGenerateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DefaultHeader(title: "Text"),
                    const SizedBox(height: 50),
                    FractionallySizedBox(
                      widthFactor: 0.94,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              width: 5,
                              color: AppColors.primaryDark,
                            ),
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/generate/text.png",
                                      height: 80,
                                      width: 80,
                                    ),
                                    const SizedBox(height: 10),
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          CustomTextField(
                                            controller: textController,
                                            title: "Text",
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),

                                    DefaultButton(
                                      title: "Generate QR Code",
                                      onPress: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => TextResultScreen(
                                                  textData: textController.text,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
