class AddEmployeesRequestBody {
  final String? id;
  final String displayName;
  final String image;
  final dynamic faceId;

  AddEmployeesRequestBody({
    this.id,
    required this.displayName,
    required this.image,
    required this.faceId,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "displayName": displayName,
        "image": image,
        "faceId": faceId,
      };
}
