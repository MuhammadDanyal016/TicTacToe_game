import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/game_model.dart';
import '../services/ai_service.dart';
import '../utils/constants.dart';
import '../widgets/game_board.dart';
import '../widgets/score_board.dart';
import '../widgets/game_controls.dart';

class GameScreen extends StatefulWidget {
  final GameMode gameMode;
  final Difficulty difficulty;

  const GameScreen({
    super.key,
    required this.gameMode,
    this.difficulty = Difficulty.medium,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin {
  late GameModel _game;
  late AnimationController _boardAnimationController;
  late AnimationController _resultAnimationController;
  bool _isAIThinking = false;

  @override
  void initState() {
    super.initState();
    _game = GameModel(
      gameMode: widget.gameMode,
      difficulty: widget.difficulty,
    );
    
    _boardAnimationController = AnimationController(
      duration: GameConstants.animationDuration,
      vsync: this,
    );
    
    _resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _boardAnimationController.forward();
  }

  @override
  void dispose() {
    _boardAnimationController.dispose();
    _resultAnimationController.dispose();
    super.dispose();
  }

  void _onCellTapped(int index) {
    if (_isAIThinking) return;
    
    HapticFeedback.lightImpact();
    
    if (_game.makeMove(index)) {
      setState(() {});
      
      if (_game.gameState != GameState.playing) {
        _showGameResult();
      } else if (_game.gameMode == GameMode.singlePlayer && 
                 _game.currentPlayer == GameConstants.playerO) {
        _makeAIMove();
      }
    }
  }

  void _makeAIMove() async {
    setState(() {
      _isAIThinking = true;
    });
    
    await Future.delayed(GameConstants.aiThinkingDuration);
    
    int aiMove = AIService.getBestMove(_game);
    if (aiMove != -1) {
      _game.makeMove(aiMove);
      setState(() {
        _isAIThinking = false;
      });
      
      if (_game.gameState != GameState.playing) {
        _showGameResult();
      }
    }
  }

  void _showGameResult() {
    _resultAnimationController.forward();
    
    String message;
    if (_game.gameState == GameState.won) {
      if (_game.gameMode == GameMode.singlePlayer) {
        message = _game.winner == GameConstants.playerX 
            ? 'You Win! 🎉' 
            : 'AI Wins! 🤖';
      } else {
        message = 'Player ${_game.winner} Wins! 🎉';
      }
    } else {
      message = 'It\'s a Draw! 🤝';
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Game Over',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _resetGame();
                  },
                  child: const Text('Play Again'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Home'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _resetGame() {
    _game.resetGame();
    _resultAnimationController.reset();
    setState(() {
      _isAIThinking = false;
    });
  }

  void _resetScores() {
    _game.resetScores();
    _resetGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _game.gameMode == GameMode.singlePlayer 
              ? 'vs Computer' 
              : 'Two Players',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetScores,
            tooltip: 'Reset Scores',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ScoreBoard(game: _game),
                const SizedBox(height: 24),
                Expanded(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _boardAnimationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _boardAnimationController.value,
                          child: GameBoard(
                            game: _game,
                            onCellTapped: _onCellTapped,
                            isAIThinking: _isAIThinking,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                GameControls(
                  game: _game,
                  onResetGame: _resetGame,
                  onResetScores: _resetScores,
                  isAIThinking: _isAIThinking,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
