import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:garda_green/gen/assets.gen.dart';
import 'package:garda_green/utils/utils.dart';
import 'package:nes_ui/nes_ui.dart';

class Instruction extends Equatable {
  const Instruction({
    required this.title,
    required this.description,
    required this.assetPath,
  });

  final String title;
  final String description;
  final String assetPath;

  @override
  List<Object> get props => [title, description, assetPath];
}

final List<Instruction> _instructions = [
  Instruction(
    title: "Hi! I'm Lila!",
    description: 'Welcome to Garda Green! In this game, you will protect the '
        'environment by avoiding single-use plastics. Are you ready to play?',
    assetPath: Assets.waste.lila.path,
  ),
  Instruction(
    title: 'Star',
    description:
        'Stars are collected points in this game. Gather and convert them into '
        'scores. More stars mean a greater contribution.',
    assetPath: Assets.waste.star.path,
  ),
  Instruction(
    title: 'Plastic Bag',
    description:
        'The plastic bag is the main enemy of the game. You will need to '
        'avoid the plastic bag to protect the environment.',
    assetPath: Assets.waste.plasticBag.path,
  ),
  Instruction(
    title: 'Plastic Cup',
    description:
        'The plastic cup is the main enemy of the game. You will need to avoid '
        'the plastic cup to protect the environment.',
    assetPath: Assets.waste.plasticCup.path,
  ),
  Instruction(
    title: 'And Many More',
    description:
        'There are many more single-use plastics that you will need to avoid.',
    assetPath: Assets.waste.trashPile.path,
  ),
  Instruction(
    title: 'Play!',
    description: 'Now you are ready to play the game. Good luck!',
    assetPath: Assets.waste.lila.path,
  ),
];

class IntroductionDialog extends StatefulWidget {
  const IntroductionDialog({super.key});

  @override
  State<IntroductionDialog> createState() => _IntroductionDialogState();
}

class _IntroductionDialogState extends State<IntroductionDialog> {
  final _index = ValueNotifier<int>(0);

  @override
  void dispose() {
    _index.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Material(
          color: Colors.transparent,
          child: IntrinsicWidth(
            stepHeight: 0.56,
            child: SizedBox.expand(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ValueListenableBuilder(
                    valueListenable: _index,
                    builder: (context, value, child) {
                      return NesContainer(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 400,
                              minHeight: 400,
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 24),
                                Image.asset(
                                  _instructions[value].assetPath,
                                  width: 84,
                                  height: 84,
                                ),
                                const Spacer(),
                                const SizedBox(height: 8),
                                NesRunningText(
                                  text: _instructions[value].title,
                                  textStyle: TextStyle(
                                    fontSize: context.isSmall ? 18 : 20,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _instructions[value].description,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: context.isSmall ? 12 : 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        minWidth: 100,
                                      ),
                                      child: WobblyButton(
                                        type: NesButtonType.success,
                                        onPressed: value == 0
                                            ? null
                                            : () {
                                                _index.value = value - 1;
                                              },
                                        child: const Text(
                                          'Prev',
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        minWidth: 100,
                                      ),
                                      child: WobblyButton(
                                        type: NesButtonType.success,
                                        child: Text(
                                          value == _instructions.length - 1
                                              ? 'Done'
                                              : 'Next',
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        onPressed: () {
                                          if (value ==
                                              _instructions.length - 1) {
                                            Navigator.of(context).pop();
                                          } else {
                                            _index.value = value + 1;
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: -8,
                    top: -8,
                    child: NesButton(
                      type: NesButtonType.error,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: NesIcon(
                        size: const Size(16, 16),
                        iconData: NesIcons.close,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
