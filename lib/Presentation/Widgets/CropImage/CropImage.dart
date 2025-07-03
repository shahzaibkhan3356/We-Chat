import 'package:crop_your_image/crop_your_image.dart' as crop_pkg;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'crop_bloc.dart';
import 'crop_bloc_state.dart';

class CropImage extends StatelessWidget {
  final String path;
  const CropImage({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CropBloc()..loadImage(path),
      child: BlocConsumer<CropBloc, CropState>(
        listener: (context, state) async {
          if (state is CropSuccess) {
            Navigator.of(context).pop(state.croppedFilePath);
          }
        },
        builder: (context, state) {
          if (state is CropLoading || state is CropInitial) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is CropError) {
            return Scaffold(body: Center(child: Text(state.message)));
          } else if (state is CropLoaded) {
            final controller = crop_pkg.CropController();
            return Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: [
                  Center(
                    child: crop_pkg.Crop(
                      controller: controller,
                      image: state.imageBytes,
                      onCropped: (result) async {
                        if (result is crop_pkg.CropSuccess) {
                          // Use compute to save file off the main thread
                          context.read<CropBloc>().processCrop(
                            result.croppedImage,
                          );
                          // Delay pop until after the next frame to avoid context issues
                          // await Future.delayed(
                          //   const Duration(milliseconds: 100),
                          // );
                        } else if (result is crop_pkg.CropFailure) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Cropping failed: ${result.cause}',
                                ),
                              ),
                            );
                          }
                        }
                      },
                      withCircleUi: true,
                      initialRectBuilder:
                          crop_pkg.InitialRectBuilder.withSizeAndRatio(
                            size: 1,
                            aspectRatio: 1,
                          ),
                      cornerDotBuilder: (size, edgeAlignment) =>
                          const DotControl(),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () => controller.cropCircle(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state is CropProcessing)
                    Container(
                      color: Colors.black38,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class DotControl extends StatelessWidget {
  const DotControl({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue, width: 2),
        shape: BoxShape.circle,
      ),
    );
  }
}
