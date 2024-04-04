class ProductM{
  String? productId;
  String? userId;
  String? category;
  String? productName;
  String? description;
  String? productImages;
  String? status;
  double newPrice;
  double oldPrice;
  double tiveleFee;
  double gstFee;
  double shippingFee;
  String? productLatitude;
  String? productLongitude;

  ProductM(
      this.productId,
      this.userId,
      this.category,
      this.productName,
      this.description,
      this.productImages,
      this.status,
      this.newPrice,
      this.oldPrice,
      this.tiveleFee,
      this.gstFee,
      this.shippingFee,
      this.productLatitude,
      this.productLongitude);
}