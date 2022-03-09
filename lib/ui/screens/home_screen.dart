import 'package:flutter/material.dart';
import 'package:img_voice_to_text/ui/widgets/voice_to_text.dart';

import '../widgets/text_from_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<bool>? _isOpen = [true, false];

  @override
  Widget build(BuildContext context) {
    final headlineTextStyle = Theme.of(context).textTheme.headline1;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Handless text'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 7),
          child: ExpansionPanelList(
            children: [
              ExpansionPanel(
                  headerBuilder: (context, isExpanded) => Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Text from image',
                          style: headlineTextStyle,
                        ),
                      ),
                  body: const TextFromImage(),
                  isExpanded: _isOpen![0],
                  canTapOnHeader: true),
              ExpansionPanel(
                  headerBuilder: (context, isExpanded) => Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Voice to text',
                          style: headlineTextStyle,
                        ),
                      ),
                  body: const VoiceToText(),
                  isExpanded: _isOpen![1],
                  canTapOnHeader: true),
            ],
            expansionCallback: (i, isOpen) {
              setState(() {
                _isOpen![i] = !isOpen;
              });
            },
            dividerColor: const Color(0xff678983),
            elevation: 6,
            expandedHeaderPadding: const EdgeInsets.all(8.0),
          ),
        ),
      ),
    );
  }
}
