enum ElementType {
  text,
  image,
  paint,
}

extension ElementTypeX on ElementType {
  String toPrettyString() {
    if (this == ElementType.text) {
      return 'text';
    }

    if (this == ElementType.image) {
      return 'text';
    }

    if (this == ElementType.paint) {
      return 'text';
    }

    return 'unknown';
  }
}
