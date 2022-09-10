import 'state.dart';

class Classes {
  DateTime updated = DateTime.fromMillisecondsSinceEpoch(0);

  void update(AccountState model) async {
    final url =
        'https://webapi.actic.se/persons/${model.account!.userId}/centers/${model.account!.centerId}/classes';
  }
}
