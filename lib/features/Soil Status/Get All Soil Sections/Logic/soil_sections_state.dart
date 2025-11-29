import 'package:equatable/equatable.dart';

abstract class SoilSectionsState extends Equatable {
  const SoilSectionsState();

  @override
  List<Object?> get props => [];
}

class SoilSectionsInitial extends SoilSectionsState {}

class SoilSectionsLoading extends SoilSectionsState {}

class SoilSectionsSuccess extends SoilSectionsState {
  final List<String> sections;
  final int count;
  final String message;

  const SoilSectionsSuccess({
    required this.sections,
    required this.count,
    required this.message,
  });

  @override
  List<Object?> get props => [sections, count, message];
}

class SoilSectionsFailure extends SoilSectionsState {
  final String failureMessage;

  const SoilSectionsFailure(this.failureMessage);

  @override
  List<Object?> get props => [failureMessage];
}

