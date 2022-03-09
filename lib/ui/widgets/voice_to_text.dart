import 'package:flutter/material.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class VoiceToText extends StatefulWidget {
  const VoiceToText({Key? key}) : super(key: key);

  @override
  State<VoiceToText> createState() => _VoiceToTextState();
}

class _VoiceToTextState extends State<VoiceToText> {
  stt.SpeechToText _speech = stt.SpeechToText();
  double _confidence = 1.0;
  bool _isListening = false;
  String _text = '';
  String levelChanges = '';
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    final textThemeStyle = Theme.of(context).textTheme;

    return SingleChildScrollView(
      reverse: true,
      child: Column(
        children: [
          Text(
            'confident ${(_confidence * 100).toStringAsFixed(1)}%',
            style: textThemeStyle.bodyText1,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(levelChanges, style: textThemeStyle.bodyText1),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SelectableText(_text.isEmpty? 'Tap the microphone to start listening... ' : _text, style: textThemeStyle.bodyText2),
          ),
          AvatarGlow(
            animate: _isListening,
            glowColor: const Color(0xff181D31),
            endRadius: 60.0,
            duration: const Duration(milliseconds: 2000),
            repeat: true,
            showTwoGlows: true,
            repeatPauseDuration: const Duration(milliseconds: 50),
            child: FloatingActionButton(
              onPressed: _listen,
              tooltip: 'Listen',
              child: _speech.isNotListening
                  ? const Icon(Icons.mic)
                  : const Icon(Icons.mic_none),
            ),
          ),
          Visibility(
              visible: _text.isEmpty ? false : true,
              child: TextButton(onPressed: (){
                setState(() {
                  levelChanges = '' ;
                  _text = '';
                  _confidence = 0.0;
                });
              }, child: Text('Reset' , style: textThemeStyle.bodyText1,)))
        ],
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onSoundLevelChange: (level) {
            if (level < 20 && level >0 && _text.isNotEmpty) {
              levelChanges = 'Raise up your voice please';
            }
          },
          cancelOnError: true,
          onResult: (val) => _onSpeechResult(val),
        );
      }
    } else {
      _stopListening();
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _text = result.recognizedWords;
      if (result.hasConfidenceRating && result.confidence > 0) {
        _confidence = result.confidence;
      }
      _isListening = false;
    });
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
    });
  }
}
