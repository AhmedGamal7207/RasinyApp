class Constants {
  static List<String> possibleStatuses = [
    "under_review",
    "approved",
    "rejected",
  ];
  static const possibleCollections = [
    "parking",
    "tint",
    "stickers",
    "wrong_way",
    "modified",
  ];
  static const featuresTitles = {
    "parking": "Wrong Parking",
    "tint": "Tinted Windows",
    "stickers": "Stickers",
    "wrong_way": "Wrong-Way Driving",
    "modified": "Modified Cars",
  };

  static const inverseFeaturesTitles = {
    "Wrong Parking": "parking",
    "Tinted Windows": "tint",
    "Stickers": "stickers",
    "Wrong-Way Driving": "wrong_way",
    "Modified Cars": "modified",
  };

  static const statsTitles = {
    "under_review": "Under Review",
    "approved": "Approved",
    "rejected": "Rejected",
  };

  static const inverseStatsTitles = {
    "Under Review": "under_review",
    "Approved": "approved",
    "Rejected": "rejected",
  };
}
