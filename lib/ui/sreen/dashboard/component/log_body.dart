import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/model/packet.dart';
import 'package:loving/preset/base_preset.dart';

import '../../../component/log_list.dart';
import 'log_body_state.dart';

class LogBody extends HookConsumerWidget {
  const LogBody({
    super.key,
    required this.packets,
    required this.presets,
    required this.isRunning,
    required this.selectedPreset,
    required this.onSelectPreset,
    required this.onToggleStart,
  });

  final List<Packet> packets;
  final List<BasePreset> presets;
  final bool isRunning;
  final BasePreset? selectedPreset;
  final Function(BasePreset?) onSelectPreset;
  final Function() onToggleStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final logBodyState = ref.watch(logBodyProvider);

    Widget cmdDropDown() {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<BasePreset>(
              isExpanded: true,
              hint: const Text(
                'Select preset commands...',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              value: selectedPreset,
              items: presets.map((BasePreset value) {
                return DropdownMenuItem<BasePreset>(
                  value: value,
                  child: Text(
                    value.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
              onChanged: isRunning
                  ? null
                  : (BasePreset? newValue) {
                      onSelectPreset(newValue);
                    },
            ),
          ),
        ),
      );
    }

    Widget cmdSection() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          cmdDropDown(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: isRunning ? null : 0,
            child: Row(
              children: [
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    ref.read(logBodyProvider.notifier).toggleHideOptions();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: SizedBox(
                    height: 46,
                    child: logBodyState.hideOptions
                        ? const Icon(Icons.open_in_full)
                        : const Icon(Icons.close_fullscreen),
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: selectedPreset != null ? null : 0,
            child: Row(
              children: [
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: selectedPreset == null
                      ? null
                      : () {
                          if (isRunning) {
                            ref
                                .read(logBodyProvider.notifier)
                                .setHideOptions(false);
                          }
                          onToggleStart();
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: SizedBox(
                    height: 46,
                    child: isRunning
                        ? Row(
                            children: [
                              const Icon(Icons.stop, color: Colors.red),
                              const SizedBox(width: 8),
                              Text(
                                'Stop',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(color: Colors.red),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              const Icon(Icons.play_arrow),
                              const SizedBox(width: 8),
                              Text(
                                'Start',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (packets.isEmpty) {
      return const Center(child: Text('Waiting socket client to connect...'));
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: cmdSection(),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Visibility(
              visible:
                  (!isRunning || !logBodyState.hideOptions) &&
                  selectedPreset != null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: selectedPreset?.options(context),
              ),
            ),
          ),
          Expanded(
            child: LogList(
              packets: packets.reversed.toList()..take(100),
              scrollController: scrollController,
            ),
          ),
        ],
      );
    }
  }
}
