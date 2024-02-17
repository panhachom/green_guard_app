class PredictionModel {
  final String name;
  final double probability;

  PredictionModel(this.name, this.probability);

  static PredictionModel findMaxProbability(List<PredictionModel> predictions) {
    if (predictions.isEmpty) {
      throw Exception('Empty list of predictions');
    }

    PredictionModel maxPrediction = predictions.first;

    for (var prediction in predictions) {
      if (prediction.probability > maxPrediction.probability) {
        maxPrediction = prediction;
      }
    }

    return maxPrediction;
  }
}
