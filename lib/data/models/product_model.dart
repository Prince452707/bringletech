import '../../domain/entities/product_entity.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel({
    required super.rating,
    required super.comment,
    required super.date,
    required super.reviewerName,
    required super.reviewerEmail,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      date: json['date'] ?? '',
      reviewerName: json['reviewerName'] ?? '',
      reviewerEmail: json['reviewerEmail'] ?? '',
    );
  }
}

class DimensionsModel extends DimensionsEntity {
  DimensionsModel({
    required super.width,
    required super.height,
    required super.depth,
  });

  factory DimensionsModel.fromJson(Map<String, dynamic> json) {
    return DimensionsModel(
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      depth: (json['depth'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.rating,
    required super.thumbnail,
    required super.images,
    required super.category,
    required super.brand,
    super.discountPercentage,
    super.stock,
    super.sku,
    super.weight,
    super.dimensions,
    super.warrantyInformation,
    super.shippingInformation,
    super.availabilityStatus,
    super.reviews,
    super.returnPolicy,
    super.minimumOrderQuantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      thumbnail: json['thumbnail'] ?? '',
      images: (json['images'] as List?)?.map((e) => e as String).toList() ?? [],
      category: json['category'] ?? '',
      brand: json['brand'] ?? '',
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
      sku: json['sku'] ?? '',
      weight: json['weight'] ?? 0,
      dimensions: json['dimensions'] != null
          ? DimensionsModel.fromJson(json['dimensions'])
          : null,
      warrantyInformation: json['warrantyInformation'] ?? '',
      shippingInformation: json['shippingInformation'] ?? '',
      availabilityStatus: json['availabilityStatus'] ?? '',
      reviews:
          (json['reviews'] as List?)
              ?.map((e) => ReviewModel.fromJson(e))
              .toList() ??
          [],
      returnPolicy: json['returnPolicy'] ?? '',
      minimumOrderQuantity: json['minimumOrderQuantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'brand': brand,
      'thumbnail': thumbnail,
    };
  }
}
