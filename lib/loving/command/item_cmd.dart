import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../socket/socket_client.dart';
import 'base_cmd.dart';

final itemCmdProvider = Provider<ItemCmd>((ref) {
  final client = ref.read(socketProvider);
  return ItemCmd(ref, client);
});

class ItemCmd extends BaseCmd {
  ItemCmd(super.ref, super.client);
}
