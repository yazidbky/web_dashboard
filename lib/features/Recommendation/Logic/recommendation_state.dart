import 'package:equatable/equatable.dart';
import 'package:web_dashboard/features/Recommendation/Data/Models/Sub%20Models/recommendation_data_model.dart';

abstract class RecommendationState extends Equatable {
  const RecommendationState();

  @override
  List<Object?> get props => [];
}

class RecommendationInitial extends RecommendationState {}

class RecommendationLoading extends RecommendationState {}

class RecommendationSuccess extends RecommendationState {
  final RecommendationDataModel recommendationData;
  final String message;

  const RecommendationSuccess({
    required this.recommendationData,
    required this.message,
  });

  @override
  List<Object?> get props => [recommendationData, message];
}

class RecommendationFailure extends RecommendationState {
  final String failureMessage;

  const RecommendationFailure(this.failureMessage);

  @override
  List<Object?> get props => [failureMessage];
}

