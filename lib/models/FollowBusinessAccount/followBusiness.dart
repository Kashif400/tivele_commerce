class Autogenerated {
  int? totalCount;
  List<Items>? items;

  Autogenerated({this.totalCount, this.items});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? userId;
  User? user;
  String? businessAccountId;
  BusinessAccount? businessAccount;
  String? id;

  Items(
      {this.userId,
      this.user,
      this.businessAccountId,
      this.businessAccount,
      this.id});

  Items.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    businessAccountId = json['businessAccountId'];
    businessAccount = json['businessAccount'] != null
        ? new BusinessAccount.fromJson(json['businessAccount'])
        : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['businessAccountId'] = this.businessAccountId;
    if (this.businessAccount != null) {
      data['businessAccount'] = this.businessAccount!.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}

class User {
  String? userName;
  String? name;
  String? surname;
  String? emailAddress;
  bool? isActive;
  String? fullName;
  String? lastLoginTime;
  String? creationTime;
  List<String>? roleNames;
  String? userProfileId;
  UserProfile? userProfile;
  int? id;

  User(
      {this.userName,
      this.name,
      this.surname,
      this.emailAddress,
      this.isActive,
      this.fullName,
      this.lastLoginTime,
      this.creationTime,
      this.roleNames,
      this.userProfileId,
      this.userProfile,
      this.id});

  User.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    name = json['name'];
    surname = json['surname'];
    emailAddress = json['emailAddress'];
    isActive = json['isActive'];
    fullName = json['fullName'];
    lastLoginTime = json['lastLoginTime'];
    creationTime = json['creationTime'];
    roleNames = json['roleNames'].cast<String>();
    userProfileId = json['userProfileId'];
    userProfile = json['userProfile'] != null
        ? new UserProfile.fromJson(json['userProfile'])
        : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['emailAddress'] = this.emailAddress;
    data['isActive'] = this.isActive;
    data['fullName'] = this.fullName;
    data['lastLoginTime'] = this.lastLoginTime;
    data['creationTime'] = this.creationTime;
    data['roleNames'] = this.roleNames;
    data['userProfileId'] = this.userProfileId;
    if (this.userProfile != null) {
      data['userProfile'] = this.userProfile!.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}

class UserProfile {
  String? contentType;
  int? length;
  String? name;
  String? fileName;
  String? fileKey;
  String? url;
  String? id;

  UserProfile(
      {this.contentType,
      this.length,
      this.name,
      this.fileName,
      this.fileKey,
      this.url,
      this.id});

  UserProfile.fromJson(Map<String, dynamic> json) {
    contentType = json['contentType'];
    length = json['length'];
    name = json['name'];
    fileName = json['fileName'];
    fileKey = json['fileKey'];
    url = json['url'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contentType'] = this.contentType;
    data['length'] = this.length;
    data['name'] = this.name;
    data['fileName'] = this.fileName;
    data['fileKey'] = this.fileKey;
    data['url'] = this.url;
    data['id'] = this.id;
    return data;
  }
}

class BusinessAccount {
  int? userId;
  User? businessUser;
  String? name;
  String? description;
  bool? isReputable;
  String? businessAccountImageId;
  UserProfile? businessAccountImage;
  int? status;
  int? accountId;
  String? locationId;
  Location? location;
  int? likeCount;
  int? followCount;
  int? productCount;
  String? id;

  BusinessAccount(
      {this.userId,
      this.businessUser,
      this.name,
      this.description,
      this.isReputable,
      this.businessAccountImageId,
      this.businessAccountImage,
      this.status,
      this.accountId,
      this.locationId,
      this.location,
      this.likeCount,
      this.followCount,
      this.productCount,
      this.id});

  BusinessAccount.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    businessUser = json['businessUser'] != null
        ? new User.fromJson(json['businessUser'])
        : null;
    name = json['name'];
    description = json['description'];
    isReputable = json['isReputable'];
    businessAccountImageId = json['businessAccountImageId'];
    businessAccountImage = json['businessAccountImage'] != null
        ? new UserProfile.fromJson(json['businessAccountImage'])
        : null;
    status = json['status'];
    accountId = json['accountId'];
    locationId = json['locationId'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    likeCount = json['likeCount'];
    followCount = json['followCount'];
    productCount = json['productCount'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    if (this.businessUser != null) {
      data['businessUser'] = this.businessUser!.toJson();
    }
    data['name'] = this.name;
    data['description'] = this.description;
    data['isReputable'] = this.isReputable;
    data['businessAccountImageId'] = this.businessAccountImageId;
    if (this.businessAccountImage != null) {
      data['businessAccountImage'] = this.businessAccountImage!.toJson();
    }
    data['status'] = this.status;
    data['accountId'] = this.accountId;
    data['locationId'] = this.locationId;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['likeCount'] = this.likeCount;
    data['followCount'] = this.followCount;
    data['productCount'] = this.productCount;
    data['id'] = this.id;
    return data;
  }
}

class Location {
  String? address1;
  String? city;
  String? state;
  String? country;
  String? postalCode;
  String? latitude;
  String? longitude;
  String? id;

  Location(
      {this.address1,
      this.city,
      this.state,
      this.country,
      this.postalCode,
      this.latitude,
      this.longitude,
      this.id});

  Location.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    postalCode = json['postalCode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address1'] = this.address1;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['postalCode'] = this.postalCode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['id'] = this.id;
    return data;
  }
}
