import 'dart:math';
import '../models/game_model.dart';
import '../utils/constants.dart';

class AIService {
  static final Random _random = Random();

  static int getBestMove(GameModel game) {
    switch (game.difficulty) {
      case Difficulty.easy:
        return _getRandomMove(game);
      case Difficulty.medium:
        return _getMediumMove(game);
      case Difficulty.hard:
        return _getHardMove(game);
    }
  }

  static int _getRandomMove(GameModel game) {
    List<int> availableMoves = game.getAvailableMoves();
    if (availableMoves.isEmpty) return -1;
    return availableMoves[_random.nextInt(availableMoves.length)];
  }

  static int _getMediumMove(GameModel game) {
    // 70% chance to play optimally, 30% chance to play randomly
    if (_random.nextDouble() < 0.7) {
      return _getHardMove(game);
    } else {
      return _getRandomMove(game);
    }
  }

  static int _getHardMove(GameModel game) {
    // Use minimax algorithm for optimal play
    int bestScore = -1000;
    int bestMove = -1;
    
    List<int> availableMoves = game.getAvailableMoves();
    
    for (int move in availableMoves) {
      GameModel tempGame = game.copyWith();
      tempGame.makeMove(move);
      
      int score = _minimax(tempGame, 0, false);
      
      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }
    
    return bestMove != -1 ? bestMove : _getRandomMove(game);
  }

  static int _minimax(GameModel game, int depth, bool isMaximizing) {
    if (game.gameState == GameState.won) {
      if (game.winner == GameConstants.playerO) {
        return 10 - depth;
      } else {
        return depth - 10;
      }
    }
    
    if (game.gameState == GameState.draw) {
      return 0;
    }

    if (isMaximizing) {
      int bestScore = -1000;
      List<int> availableMoves = game.getAvailableMoves();
      
      for (int move in availableMoves) {
        GameModel tempGame = game.copyWith();
        tempGame.makeMove(move);
        int score = _minimax(tempGame, depth + 1, false);
        bestScore = max(score, bestScore);
      }
      
      return bestScore;
    } else {
      int bestScore = 1000;
      List<int> availableMoves = game.getAvailableMoves();
      
      for (int move in availableMoves) {
        GameModel tempGame = game.copyWith();
        tempGame.makeMove(move);
        int score = _minimax(tempGame, depth + 1, true);
        bestScore = min(score, bestScore);
      }
      
      return bestScore;
    }
  }
}
