class GameConstants {
  static const int boardSize = 3;
  static const String playerX = 'X';
  static const String playerO = 'O';
  static const String empty = '';
  
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration aiThinkingDuration = Duration(milliseconds: 800);
  
  static const List<List<int>> winningCombinations = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
    [0, 4, 8], [2, 4, 6], // Diagonals
  ];
}

enum GameMode { singlePlayer, twoPlayer }
enum GameState { playing, won, draw }
enum Difficulty { easy, medium, hard }
