import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:kiddo_math/Data/MathFacts.dart';

class MathFactsScreen extends StatefulWidget {
  MathFactsScreen({@required Key key, @required this.title}): super(key: key);
  final String title;

  @override
  MathFactsScreenState createState() => MathFactsScreenState();
}

class MathFactsScreenState extends State<MathFactsScreen> {

  final TextEditingController _answerController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  MathFacts _mathFacts;
  Ticker _ticker;
  Iterator<Problem> _problemsIterator;
  String _currentProblem = '';
  String _currentTime = '';
  bool _timerIsVisible = false;
  bool _quizIsRunning = false;

  @override void initState() {
    super.initState();

    _ticker = Ticker(tickHandler);
  }

  @override void dispose() {
    _ticker.stop();
    _ticker.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  void tickHandler(Duration elapsed) {
    _currentTime = '${elapsed.inMinutes.toString().padLeft(1, '0')}:${elapsed.inSeconds.toString().padLeft(2, '0')}';
    setState(() {

    });
  }

  void updateCurrentProblem() {
    if (_problemsIterator.moveNext()) {
      _currentProblem = _problemsIterator.current.toString();
    } else {
      _currentProblem = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Start'),
              onPressed: _quizIsRunning ? null : () => startQuiz(),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Visibility(
                    visible: _quizIsRunning,
                    child: Text(_currentProblem),
                  ),
                ),
                Expanded(
                  child: Visibility(
                    visible: _quizIsRunning,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                      focusNode: _focusNode,
                      controller: _answerController,
                      onSubmitted: (answer) {
                        handleAnswerSubmission(answer);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Visibility(
                    visible: _timerIsVisible && _quizIsRunning,
                    child: Text(_currentTime),
                  ),
                ),
                Expanded(
                  child: Visibility(
                    visible: _quizIsRunning,
                    child: Checkbox(
                      value: _timerIsVisible,
                      onChanged: (newValue) {
                        _timerIsVisible = newValue;
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void startQuiz() {
    _mathFacts = MathFacts(
        numAddition: 2,
        numSubtraction: 2,
        numMultiplication: 2,
        numDivision: 2,
        summandMin: 2,
        summandMax: 50,
        additionMax: 55,
        multiplicandMin: 2,
        multiplicandMax: 50,
        productMax: 55);
    _problemsIterator = _mathFacts.problems;
    updateCurrentProblem();
    _ticker.start();
    _timerIsVisible = true;
    _quizIsRunning = true;
    _focusNode.requestFocus();
    setState(() {});
  }

  void handleAnswerSubmission(String answer) {
    if (int.parse(answer) == _problemsIterator.current.answer) {
      updateCurrentProblem();
    }

    _answerController.clear();

    if (_currentProblem.isNotEmpty) {
      _focusNode.requestFocus();
    } else {
      _ticker.stop();
      _timerIsVisible = _quizIsRunning = false;
    }

    setState(() {
    });
  }
}
