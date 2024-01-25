import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/prompt_viewmodel.dart';

class CreatePromptScreen extends StatefulWidget {
  const CreatePromptScreen({Key? key}) : super(key: key);

  @override
  State<CreatePromptScreen> createState() => _CreatePromptScreenState();
}

class _CreatePromptScreenState extends State<CreatePromptScreen> {
  TextEditingController controller = TextEditingController();
  late Timer _timer;
  int _hintIndex = 0;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 2000), (timer) {
      if (!_isKeyboardVisible) {
        setState(() {
          _hintIndex = (_hintIndex + 1) % hints.length;
        });
      }
    });

    // Listen for changes in focus to determine keyboard visibility
    FocusManager.instance.primaryFocus?.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _timer.cancel();
    // Remove the focus listener when the widget is disposed
    FocusManager.instance.primaryFocus?.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isKeyboardVisible =
          FocusManager.instance.primaryFocus?.hasFocus ?? false;
    });

    // Restart or stop the timer based on keyboard visibility
    if (_isKeyboardVisible) {
      _timer.cancel();
    } else {
      _timer = Timer.periodic(const Duration(milliseconds: 2000), (timer) {
        if (!_isKeyboardVisible) {
          setState(() {
            _hintIndex = (_hintIndex + 1) % hints.length;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final promptViewModel = Provider.of<PromptViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Generate Images🚀"),
      ),
      body: ChangeNotifierProvider.value(
        value: promptViewModel,
        child: Consumer<PromptViewModel>(
          builder: (context, promptViewModel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: promptViewModel.isLoading
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text("Please wait, your prompt is processing..."),
                            ],
                          )
                        : promptViewModel.imageBytes.isNotEmpty
                            ? Image.memory(promptViewModel.imageBytes,
                                fit: BoxFit.cover)
                            : Image.asset('assets/file.jpg', fit: BoxFit.cover),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Enter your prompt",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText(
                                hints[_hintIndex],
                                speed: const Duration(milliseconds: 60),
                              ),
                            ],
                            repeatForever: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: controller,
                        cursorColor: Colors.deepPurple,
                        decoration: InputDecoration(
                          hintText: "Prompt me here, your Alexander...",
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.deepPurple,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.deepPurple,
                          ),
                        ),
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            promptViewModel.generateImage(controller.text);
                            controller.clear(); // Clear input field
                          }
                        },
                        icon: const Icon(Icons.image),
                        label: const Text("Generate Image"),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

List<String> hints = [
  "Write me a prompt...",
  "Crown on the head of Imran Khan the great",
];
