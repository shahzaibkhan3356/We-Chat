import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class CropState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CropInitial extends CropState {}

class CropLoading extends CropState {}

class CropLoaded extends CropState {
  final Uint8List imageBytes;
  CropLoaded(this.imageBytes);
  @override
  List<Object?> get props => [imageBytes];
}

class CropProcessing extends CropState {}

class CropSuccess extends CropState {
  final String croppedFilePath;
  CropSuccess(this.croppedFilePath);
  @override
  List<Object?> get props => [croppedFilePath];
}

class CropError extends CropState {
  final String message;
  CropError(this.message);
  @override
  List<Object?> get props => [message];
}
