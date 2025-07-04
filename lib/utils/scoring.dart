int calculateScore(
  List<Duration> userTimestamps,
  List<Duration> correctTimestamps,
) {
  const int matchThresholdMs = 1000; // Only match if within 1s
  const int penaltyPerMiss = -5;

  int score = 0;

  Set<int> matchedUserIndices = {};
  Set<int> matchedCorrectIndices = {};

  for (int i = 0; i < correctTimestamps.length; i++) {
    Duration correct = correctTimestamps[i];
    double closestDiff = double.infinity;
    int? bestMatchIndex;

    for (int j = 0; j < userTimestamps.length; j++) {
      if (matchedUserIndices.contains(j)) continue;

      Duration user = userTimestamps[j];
      double diff = (user.inMilliseconds - correct.inMilliseconds)
          .abs()
          .toDouble();

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
    }
  }

  // Unmatched user timestamps → -5 each
  int unmatchedUserCount = userTimestamps.length - matchedUserIndices.length;
  score += unmatchedUserCount * penaltyPerMiss;

  // Unmatched correct timestamps → -5 each
  int unmatchedCorrectCount =
      correctTimestamps.length - matchedCorrectIndices.length;
  score += unmatchedCorrectCount * penaltyPerMiss;

  return score;
}
