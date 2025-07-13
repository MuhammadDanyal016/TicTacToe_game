import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../utils/constants.dart';

class GameControls extends StatelessWidget {
  final GameModel game;
  final VoidCallback onResetGame;
  final VoidCallback onResetScores;
  final bool isAIThinking;

  const GameControls({
    super.key,
    required this.game,
    required this.onResetGame,
    required this.onResetScores,
    this.isAIThinking = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (game.gameState == GameState.playing)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isAIThinking) ...[
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI is thinking...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ] else ...[
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    game.gameMode == GameMode.singlePlayer
                        ? (game.currentPlayer == GameConstants.playerX 
                            ? 'Your turn' 
                            : 'AI\'s turn')
                        : 'Player ${game.currentPlayer}\'s turn',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: onResetGame,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('New Game'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            OutlinedButton.icon(
              onPressed: onResetScores,
              icon: const Icon(Icons.clear_all, size: 18),
              label: const Text('Reset Scores'),
            ),
          ],
        ),
      ],
    );
  }
}
