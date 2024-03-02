import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garda_green/game/score/input_initials/formatters/formatters.dart';
import 'package:garda_green/game/score/score.dart';
import 'package:garda_green/game/view/game_view.dart';
import 'package:garda_green/l10n/l10n.dart';
import 'package:garda_green/utils/components/components.dart';
import 'package:nes_ui/nes_ui.dart';

class InitialsFormView extends StatefulWidget {
  const InitialsFormView({super.key});

  @override
  State<InitialsFormView> createState() => _InitialsFormViewState();
}

class _InitialsFormViewState extends State<InitialsFormView> {
  final focusNodes = List.generate(3, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<ScoreBloc, ScoreState>(
      listener: (context, state) {
        if (state.initialsStatus == InitialsFormStatus.blacklisted) {
          focusNodes.last.requestFocus();
        } else if (state.initialsStatus == InitialsFormStatus.success) {
          Navigator.pushReplacement(
            context,
            ScoreOverviewPage.route(
              initial: context.read<ScoreBloc>().state.initials.join(),
              score: context.read<ScoreBloc>().score,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.initialsStatus == InitialsFormStatus.failure) {
          return const _ErrorBody();
        }
        return Visibility(
          visible: state.initialsStatus != InitialsFormStatus.success,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _InitialFormField(
                    0,
                    focusNode: focusNodes[0],
                    key: ObjectKey(focusNodes[0]),
                    onChanged: (index, value) {
                      _onInitialChanged(context, value, index);
                    },
                    onBackspace: (index) {
                      _onInitialChanged(context, '', index, isBackspace: true);
                    },
                  ),
                  const SizedBox(width: 16),
                  _InitialFormField(
                    1,
                    key: ObjectKey(focusNodes[1]),
                    focusNode: focusNodes[1],
                    onChanged: (index, value) {
                      _onInitialChanged(context, value, index);
                    },
                    onBackspace: (index) {
                      _onInitialChanged(context, '', index, isBackspace: true);
                    },
                  ),
                  const SizedBox(width: 16),
                  _InitialFormField(
                    2,
                    key: ObjectKey(focusNodes[2]),
                    focusNode: focusNodes[2],
                    onChanged: (index, value) {
                      _onInitialChanged(context, value, index);
                    },
                    onBackspace: (index) {
                      _onInitialChanged(context, '', index, isBackspace: true);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (state.initialsStatus == InitialsFormStatus.loading)
                const NesHourglassLoadingIndicator()
              else
                WobblyButton(
                  child: Text(l10n.enterLabel),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    context
                        .read<ScoreBloc>()
                        .add(const ScoreInitialsSubmitted());
                  },
                ),
              const SizedBox(height: 16),
              if (state.initialsStatus == InitialsFormStatus.blacklisted)
                _ErrorTextWidget(l10n.initialsBlacklistedMessage)
              else if (state.initialsStatus == InitialsFormStatus.invalid)
                _ErrorTextWidget(l10n.initialsInvalidMessage),
            ],
          ),
        );
      },
    );
  }

  void _onInitialChanged(
    BuildContext context,
    String value,
    int index, {
    bool isBackspace = false,
  }) {
    var text = value;
    if (text == emptyCharacter) {
      text = '';
    }

    context
        .read<ScoreBloc>()
        .add(ScoreInitialsUpdated(character: text, index: index));
    if (text.isNotEmpty) {
      if (index < focusNodes.length - 1) {
        focusNodes[index].unfocus();
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      }
    } else if (index > 0) {
      if (isBackspace) {
        setState(() {
          focusNodes[index - 1] = FocusNode();
        });

        SchedulerBinding.instance.scheduleFrameCallback((timeStamp) {
          FocusScope.of(context).requestFocus(focusNodes[index - 1]);
        });
      }
    }
  }
}

class _InitialFormField extends StatefulWidget {
  const _InitialFormField(
    this.index, {
    required this.onChanged,
    required this.focusNode,
    required this.onBackspace,
    super.key,
  });

  final int index;
  final void Function(int, String) onChanged;
  final void Function(int) onBackspace;
  final FocusNode focusNode;

  @override
  State<_InitialFormField> createState() => _InitialFormFieldState();
}

class _InitialFormFieldState extends State<_InitialFormField> {
  late final TextEditingController controller =
      TextEditingController.fromValue(lastValue);

  bool hasFocus = false;
  TextEditingValue lastValue = const TextEditingValue(
    text: emptyCharacter,
    selection: TextSelection.collapsed(offset: 1),
  );

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(onFocusChanged);
  }

  void onFocusChanged() {
    if (mounted) {
      final hadFocus = hasFocus;
      final willFocus = widget.focusNode.hasPrimaryFocus;

      setState(() {
        hasFocus = willFocus;
      });

      if (!hadFocus && willFocus) {
        final text = controller.text;
        final selection = TextSelection.collapsed(offset: text.length);
        controller.selection = selection;
      }
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(onFocusChanged);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 72,
      child: TextFormField(
        key: Key('initial_form_field_${widget.index}'),
        controller: controller,
        autofocus: widget.index == 0,
        focusNode: widget.focusNode,
        showCursor: false,
        textInputAction: TextInputAction.next,
        inputFormatters: [
          BackspaceFormatter(
            onBackspace: () => widget.onBackspace(widget.index),
          ),
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
          UpperCaseTextFormatter(),
          JustOneCharacterFormatter((value) {
            widget.onChanged(widget.index, value);
          }),
          EmptyCharacterAtEndFormatter(),
        ],
        textCapitalization: TextCapitalization.characters,
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelStyle: TextStyle(
            fontSize: 14,
          ),
        ),
        textAlign: TextAlign.center,
        onChanged: (value) {
          widget.onChanged(widget.index, value);
        },
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        const SizedBox(height: 40),
        _ErrorTextWidget(l10n.errorInputScoreMessage),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          label: Text(l10n.playAgainLabel),
          icon: const Icon(Icons.refresh, size: 16),
          onPressed: () {
            Navigator.pushReplacement(context, GameView.route());
          },
        ),
      ],
    );
  }
}

class _ErrorTextWidget extends StatelessWidget {
  const _ErrorTextWidget(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.add,
          color: Color(0xFFF48B8B),
          size: 20,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(text),
        ),
      ],
    );
  }
}
