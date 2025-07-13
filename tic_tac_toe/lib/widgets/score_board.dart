import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../utils/constants.dart';

class ScoreBoard extends StatelessWidget {
  final GameModel game;

  const ScoreBoard({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildScoreItem(
              context,
              label: game.gameMode == GameMode.singlePlayer ? 'You' : 'Player X',
              score: game.playerXScore,
              color: Theme.of(context).colorScheme.primary,
              symbol: GameConstants.playerX,
            ),
            _buildScoreItem(
              context,
              label: 'Draws',
              score: game.drawScore,
              color: Theme.of(context).colorScheme.outline,
              symbol: '=',
            ),
            _buildScoreItem(
              context,
              label: game.gameMode == GameMode.singlePlayer ? 'AI' : 'Player O',
              score: game.playerOScore,
              color: Theme.of(context).colorScheme.secondary,
              symbol: GameConstants.playerO,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem(
    BuildContext context, {
    required String label,
    required int score,
    required Color color,
    required String symbol,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              symbol,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          score.toString(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
