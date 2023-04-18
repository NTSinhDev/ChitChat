import 'package:chat_app/models/injector.dart';
import 'package:intl/intl.dart';

class ChitChatConvert {
  static List<List<Message>> convertToTimeClusters({
    required List<Message> messages,
  }) {
    List<List<Message>> clusters = [];

    String getFormatTime(DateTime dateTime) =>
        DateFormat('yyyy-MM-dd').format(dateTime);
    getTimeCluster() {
      List<Message> timeCluster = [];
      for (var i = 0; i < messages.length; i++) {
        timeCluster.add(messages[i]);
        if ((i + 1) < messages.length &&
            getFormatTime(messages[i].stampTime) ==
                getFormatTime(messages[i + 1].stampTime)) {
        } else {
          clusters.add(timeCluster);
          timeCluster = [];
        }
      }
    }

    return _hanldeCaseMessagesLength(
      messages,
      startConvert: () {
        getTimeCluster();
        clusters.sort(
          (previus, next) => previus[0].stampTime.compareTo(next[0].stampTime),
        );
        return clusters;
      },
    );
  }

  static List<List<Message>> convertToMessagesClusters({
    required List<Message> messages,
  }) {
    List<List<Message>> clusters = [];

    getMessageCluster() {
      List<Message> mesagesCluster = [];
      for (var i = 0; i < messages.length; i++) {
        mesagesCluster.add(messages[i]);
        if ((i + 1) < messages.length &&
            messages[i].senderId == messages[i + 1].senderId) {
        } else {
          clusters.add(mesagesCluster);
          mesagesCluster = [];
        }
      }
    }

    return _hanldeCaseMessagesLength(
      messages,
      startConvert: () {
        getMessageCluster();
        return clusters;
      },
    );
  }

  static List<List<Message>> _hanldeCaseMessagesLength(
    List<Message> messages, {
    required List<List<Message>> Function() startConvert,
  }) {
    switch (messages.length) {
      case 0:
        return [];
      case 1:
        return [
          [messages.first]
        ];
      default:
        return startConvert();
    }
  }
}
