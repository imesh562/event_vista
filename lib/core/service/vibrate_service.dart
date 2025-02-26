import 'package:flutter_vibrate/flutter_vibrate.dart';

class VibrateService {
  bool _canVibrate = false;

  VibrateService() {
    _initVibrateService();
  }

  _initVibrateService() async {
    _canVibrate = await Vibrate.canVibrate;
  }

  selectionFeedback() {
    if (_canVibrate) {
      Vibrate.feedback(FeedbackType.selection);
    }
  }

  successFeedback() {
    if (_canVibrate) {
      Vibrate.feedback(FeedbackType.success);
    }
  }

  errorFeedback() {
    if (_canVibrate) {
      Vibrate.feedback(FeedbackType.error);
    }
  }
}
