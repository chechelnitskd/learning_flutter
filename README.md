# ml_cat_dog_2

A new Flutter project.

Trying to piece together:
- how to write a Flutter App...
- how to use the image picker package
- how to implement TensorFlowLite model into Flutter (so far haven't gotten here yet) -- how to use the tflite package

### tutorials I've tried following
(to varying degrees of success)

https://medium.com/fabcoding/adding-an-image-picker-in-a-flutter-app-pick-images-using-camera-and-gallery-photos-7f016365d856
https://www.youtube.com/watch?v=JLhHxTDz7K8&t=1s

### Errors I had

metal_delegate.h not found -- updating the Podfile.lock, along with following the tflite package set up instructions fixed it:
https://pub.dev/packages/tflite

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
