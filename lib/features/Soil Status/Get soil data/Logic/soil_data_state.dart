import 'package:equatable/equatable.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20soil%20data/Data/Models/soil_data_model.dart';

abstract class SoilDataState extends Equatable {
  const SoilDataState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded
class SoilDataInitial extends SoilDataState {}

/// State while soil data is being fetched
class SoilDataLoading extends SoilDataState {}

/// State when soil data is successfully loaded
class SoilDataSuccess extends SoilDataState {
  final SoilDataModel soilData;
  final String message;

  const SoilDataSuccess({
    required this.soilData,
    required this.message,
  });

  @override
  List<Object?> get props => [soilData, message];
}

/// State when there's an error fetching soil data
class SoilDataFailure extends SoilDataState {
  final String errorMessage;

  const SoilDataFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

