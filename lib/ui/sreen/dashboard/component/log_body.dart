import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/model/packet.dart';
import 'package:loving/preset/base_preset.dart';

import '../../../component/log_list.dart';

class LogBody extends ConsumerStatefulWidget {
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
  ConsumerState<ConsumerStatefulWidget> createState() => _LogContentState();
}

class _LogContentState extends ConsumerState<LogBody> {
  final ScrollController _scrollController = ScrollController();
  bool _hideOptions = true;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget _cmdDropDown() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<BasePreset>(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            isExpanded: true,
            hint: const Text(
              'Select preset commands...',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            value: widget.selectedPreset,
            items:
                widget.presets.map((BasePreset value) {
                  return DropdownMenuItem<BasePreset>(
                    value: value,
                    child: Text(
                      value.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
            onChanged:
                widget.isRunning
                    ? null
                    : (BasePreset? newValue) {
                      setState(() {
                        widget.onSelectPreset(newValue);
                      });
                    },
          ),
        ),
      ),
    );
  }

  Widget _cmdSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _cmdDropDown(),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: widget.isRunning ? null : 0,
          child: Row(
            children: [
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  _hideOptions = !_hideOptions;
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: SizedBox(
                  height: 46,
                  child:
                      _hideOptions
                          ? const Icon(Icons.open_in_full)
                          : const Icon(Icons.close_fullscreen),
                ),
              ),
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: widget.selectedPreset != null ? null : 0,
          child: Row(
            children: [
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed:
                    widget.selectedPreset == null
                        ? null
                        : () {
                          setState(() {
                            if (widget.isRunning) {
                              _hideOptions = false;
                            }
                            widget.onToggleStart();
                          });
                        },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: SizedBox(
                  height: 46,
                  child:
                      widget.isRunning
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

  @override
  Widget build(BuildContext context) {
    return widget.packets.isEmpty
        ? const Center(child: Text('Waiting socket client to connect...'))
        : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: _cmdSection(),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Visibility(
                visible: !widget.isRunning || !_hideOptions,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: widget.selectedPreset?.options(context),
                ),
              ),
            ),
            Expanded(
              child: LogList(
                packets: widget.packets.reversed.toList()..take(100),
                scrollController: _scrollController,
              ),
            ),
          ],
        );
  }
}
