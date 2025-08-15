

/*part 'player.freezed.dart';
part 'player.g.dart';


@JsonEnum()
enum PlayerStatus { alive, dead, inCombat }

@freezed
abstract class Player with _$Player {
  const factory Player({
    @Default('') String charId,
    @Default('') String username,
    @Default([]) List<Item> equipments,
    @Default('') String cell,
    @Default('') String pad,
    @Default(0) int posX,
    @Default(0) int posY,
    @Default([]) List<Item> inventoryItems,
    @Default([]) List<Item> tempInventoryItems,
    @Default([]) List<Item> bankItems,
    @Default(0.0) double totalGold,
    @Default(0) int maxHP,
    @Default(0) int currentHP,
    @Default(0) int currentMP,
    @Default(PlayerStatus.alive) PlayerStatus status,
    @Default([]) List<Aura> auras,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}
*/
