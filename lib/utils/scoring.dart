import 'dart:core';

Map<String, dynamic> calculateSectionScore(
  List<Duration> userTimestamps,
  List<Duration> correctTimestamps,
) {
  const int matchThresholdMs = 1000;
  const int penaltyPerMiss = -5;

  int score = 0;
  List<Map<String, dynamic>> matches = [];
  List<Duration> missedCorrect = [];
  List<Duration> missedUser = [];

  Set<int> matchedUserIndices = {};
  Set<int> matchedCorrectIndices = {};

  for (int i = 0; i < correctTimestamps.length; i++) {
    Duration correct = correctTimestamps[i];
    double closestDiff = double.infinity;
    int? bestMatchIndex;

    for (int j = 0; j < userTimestamps.length; j++) {
      if (matchedUserIndices.contains(j)) continue;

      Duration user = userTimestamps[j];
      double diff =
          (user.inMilliseconds - correct.inMilliseconds).abs().toDouble();

      if (diff <= matchThresholdMs && diff < closestDiff) {
        closestDiff = diff;
        bestMatchIndex = j;
      }
    }

    if (bestMatchIndex != null) {
      matchedUserIndices.add(bestMatchIndex);
      matchedCorrectIndices.add(i);

      if (closestDiff < 300) {
        score += 10;
      } else {
        score += 5;
      }

      matches.add({
        'correct': correct,
        'user': userTimestamps[bestMatchIndex],
        'diff': closestDiff.round(),
      });
    } else {
      missedCorrect.add(correct);
      score += penaltyPerMiss;
    }
  }

  for (int i = 0; i < userTimestamps.length; i++) {
    if (!matchedUserIndices.contains(i)) {
      missedUser.add(userTimestamps[i]);
      score += penaltyPerMiss;
    }
  }

  return {
    'score': score,
    'matches': matches,
    'missedCorrect': missedCorrect,
    'missedUser': missedUser,
  };
}
