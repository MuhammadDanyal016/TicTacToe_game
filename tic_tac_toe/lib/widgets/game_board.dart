import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../utils/constants.dart';
import 'game_cell.dart';

class GameBoard extends StatelessWidget {
  final GameModel game;
  final Function(int) onCellTapped;
  final bool isAIThinking;

  const GameBoard({
    super.key,
    required this.game,
    required this.onCellTapped,
    this.isAIThinking = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 350,
      ),
      child: Card(
        elevation: 12,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: GameConstants.boardSize,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              return GameCell(
                value: game.board[index],
                index: index,
                onTapped: () => onCellTapped(index),
                isEnabled: game.gameState == GameState.playing && !isAIThinking,
              );
            },
          ),
        ),
      ),
    );
  }
}
