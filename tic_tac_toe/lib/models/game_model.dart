import '../utils/constants.dart';

class GameModel {
  List<String> _board;
  String _currentPlayer;
  GameMode _gameMode;
  GameState _gameState;
  String? _winner;
  int _playerXScore;
  int _playerOScore;
  int _drawScore;
  Difficulty _difficulty;

  GameModel({
    GameMode gameMode = GameMode.singlePlayer,
    Difficulty difficulty = Difficulty.medium,
  })  : _board = List.filled(9, GameConstants.empty),
        _currentPlayer = GameConstants.playerX,
        _gameMode = gameMode,
        _gameState = GameState.playing,
        _winner = null,
        _playerXScore = 0,
        _playerOScore = 0,
        _drawScore = 0,
        _difficulty = difficulty;

  // Getters
  List<String> get board => List.unmodifiable(_board);
  String get currentPlayer => _currentPlayer;
  GameMode get gameMode => _gameMode;
  GameState get gameState => _gameState;
  String? get winner => _winner;
  int get playerXScore => _playerXScore;
  int get playerOScore => _playerOScore;
  int get drawScore => _drawScore;
  Difficulty get difficulty => _difficulty;

  // Setters
  void setGameMode(GameMode mode) => _gameMode = mode;
  void setDifficulty(Difficulty difficulty) => _difficulty = difficulty;

  bool makeMove(int index) {
    if (_board[index] != GameConstants.empty || _gameState != GameState.playing) {
      return false;
    }

    _board[index] = _currentPlayer;
    _checkGameState();
    
    if (_gameState == GameState.playing) {
      _switchPlayer();
    }
    
    return true;
  }

  void _switchPlayer() {
    _currentPlayer = _currentPlayer == GameConstants.playerX 
        ? GameConstants.playerO 
        : GameConstants.playerX;
  }

  void _checkGameState() {
    // Check for winner
    for (List<int> combination in GameConstants.winningCombinations) {
      if (_board[combination[0]] != GameConstants.empty &&
          _board[combination[0]] == _board[combination[1]] &&
          _board[combination[1]] == _board[combination[2]]) {
        _gameState = GameState.won;
        _winner = _board[combination[0]];
        _updateScore();
        return;
      }
    }

    // Check for draw
    if (!_board.contains(GameConstants.empty)) {
      _gameState = GameState.draw;
      _drawScore++;
    }
  }

  void _updateScore() {
    if (_winner == GameConstants.playerX) {
      _playerXScore++;
    } else if (_winner == GameConstants.playerO) {
      _playerOScore++;
    }
  }

  void resetGame() {
    _board = List.filled(9, GameConstants.empty);
    _currentPlayer = GameConstants.playerX;
    _gameState = GameState.playing;
    _winner = null;
  }

  void resetScores() {
    _playerXScore = 0;
    _playerOScore = 0;
    _drawScore = 0;
  }

  List<int> getAvailableMoves() {
    List<int> moves = [];
    for (int i = 0; i < _board.length; i++) {
      if (_board[i] == GameConstants.empty) {
        moves.add(i);
      }
    }
    return moves;
  }

  GameModel copyWith() {
    GameModel copy = GameModel(gameMode: _gameMode, difficulty: _difficulty);
    copy._board = List.from(_board);
    copy._currentPlayer = _currentPlayer;
    copy._gameState = _gameState;
    copy._winner = _winner;
    copy._playerXScore = _playerXScore;
    copy._playerOScore = _playerOScore;
    copy._drawScore = _drawScore;
    return copy;
  }
}
