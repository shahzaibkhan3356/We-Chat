import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'crop_bloc_state.dart';

class CropBloc extends Cubit<CropState> {
  CropBloc() : super(CropInitial());

  Future<void> loadImage(String path) async {
    emit(CropLoading());
    try {
      final file = File(path);
      final bytes = await file.readAsBytes();
      emit(CropLoaded(bytes));
    } catch (e) {
      emit(CropError('Failed to load image: $e'));
    }
  }

  Future<void> processCrop(Uint8List croppedBytes) async {
    emit(CropProcessing());
    try {
      final tempDir = await getTemporaryDirectory();
      final file = await File(
        '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ).writeAsBytes(croppedBytes);
      emit(CropSuccess(file.path));
    } catch (e) {
      emit(CropError('Failed to save cropped image: $e'));
    }
  }

  void reset() => emit(CropInitial());
}
