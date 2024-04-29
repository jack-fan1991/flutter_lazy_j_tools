import 'dart:async';

mixin StreamDisposable {
  final List<StreamSubscription> _subscriptions = [];

  void cancelSubscriptions() {
    _subscriptions.forEach((subscription) {
      subscription.cancel();
    });
  }

  void addSubscription({
    required StreamSubscription subscription,
  }) {
    _subscriptions.add(subscription);
  }
}
