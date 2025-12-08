class ReviewEntity {
  final int rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;

  ReviewEntity({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });
}

class DimensionsEntity {
  final double width;
  final double height;
  final double depth;

  DimensionsEntity({
    required this.width,
    required this.height,
    required this.depth,
  });
}

class ProductEntity {
  final int id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final String thumbnail;
  final List<String> images;
  final String category;
  final String brand;
  final double discountPercentage;
  final int stock;
  final String sku;
  final int weight;
  final DimensionsEntity? dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<ReviewEntity> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;

  ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.thumbnail,
    required this.images,
    required this.category,
    required this.brand,
    this.discountPercentage = 0.0,
    this.stock = 0,
    this.sku = '',
    this.weight = 0,
    this.dimensions,
    this.warrantyInformation = '',
    this.shippingInformation = '',
    this.availabilityStatus = '',
    this.reviews = const [],
    this.returnPolicy = '',
    this.minimumOrderQuantity = 1,
  });
}
