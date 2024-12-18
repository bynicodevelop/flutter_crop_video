part of crop;

/// The controller used to control the rotation, scale and actual cropping.
class CropController extends ChangeNotifier {
  /// Constructor
  CropController({
    double aspectRatio = 1.0,
    double scale = 1.0,
    double rotation = 0,
    Offset offset = Offset.zero,
  }) {
    _aspectRatio = aspectRatio;
    _scale = scale;
    _offset = offset;
    _horizontalShift =
        rotation; // Utiliser rotation comme un décalage horizontal initial
  }

  double _aspectRatio = 1;
  double _scale = 1;
  Offset _offset = Offset.zero;
  double _horizontalShift =
      0; // Utilisé à la place de rotation pour le déplacement horizontal
  Future<ui.Image> Function(double pixelRatio)? _cropCallback;

  /// Gets the current aspect ratio.
  double get aspectRatio => _aspectRatio;

  /// Sets the desired aspect ratio.
  set aspectRatio(double value) {
    _aspectRatio = value;
    notifyListeners();
  }

  /// Gets the current scale.
  double get scale => max(_scale, 1);

  /// Sets the desired scale.
  set scale(double value) {
    _scale = value;
    notifyListeners();
  }

  /// Gets the current horizontal shift (anciennement rotation).
  double get rotation => _horizontalShift;

  /// Sets the desired horizontal shift.
  set rotation(double value) {
    _horizontalShift = value;
    _offset = Offset(
        value, _offset.dy); // Appliquer le décalage horizontal à l'offset
    notifyListeners();
  }

  /// Gets the current offset.
  Offset get offset => _offset;

  /// Sets the desired offset.
  set offset(Offset value) {
    _offset = value;
    notifyListeners();
  }

  /// Gets the transformation matrix.
  Matrix4 get transform => Matrix4.identity()
    ..translate(_offset.dx, _offset.dy, 0)
    ..scale(_scale, _scale, 1);

  double _getMinScale() {
    return 1.0;
  }

  /// Capture an image of the current state of this widget and its children.
  Future<ui.Image?> crop({double pixelRatio = 1}) {
    if (_cropCallback == null) {
      return Future.value(null);
    }
    return _cropCallback!.call(pixelRatio);
  }
}
