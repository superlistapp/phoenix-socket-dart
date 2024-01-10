import 'package:phoenix_socket/phoenix_socket.dart';
import 'package:test/test.dart';

void main() {
  test('Push.future should complete properly even after trigger', () async {
    var phoenixSocket = PhoenixSocket('');
    final channel = PhoenixChannel.fromSocket(phoenixSocket, topic: 'oui');

    var push = Push(channel, event: PhoenixChannelEvent.leave);
    push.trigger(PushResponse(status: 'ok'));

    // expect(push.future, completes);
  });

  test('test 1', () async {
    int logOkCount = 0;
    int logErrorCount = 0;
    int logTimeoutCount = 0;

    var phoenixSocket = PhoenixSocket('endpoint');
    final channel = PhoenixChannel.fromSocket(phoenixSocket, topic: 'topic');

    final push = Push(channel, event: PhoenixChannelEvent.join);
    push
      ..onReply('ok', (_) => logOkCount++)
      ..onReply('error', (_) => logErrorCount++)
      ..onReply('timeout', (_) => logTimeoutCount++);

    expect(logOkCount, equals(0));
    expect(logErrorCount, equals(0));
    expect(logTimeoutCount, equals(0));

    push.trigger(PushResponse(status: 'error'));

    expect(logOkCount, equals(0));
    expect(logErrorCount, equals(1));
    expect(logTimeoutCount, equals(0));

    push.trigger(PushResponse(status: 'timeout'));

    expect(logOkCount, equals(0));
    expect(logErrorCount, equals(1));
    expect(logTimeoutCount, equals(1));

    push.trigger(PushResponse(status: 'ok'));

    expect(logOkCount, equals(1));
    expect(logErrorCount, equals(1));
    expect(logTimeoutCount, equals(1));
  });
}
