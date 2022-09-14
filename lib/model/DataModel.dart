class DataModel {
  int? columnId;
  String columnName;
  String columnAge;

  DataModel({this.columnId, required this.columnName, required this.columnAge});

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
      columnId: json['columnId'],
      columnName: json['columnName'],
      columnAge: json['columnAge']);

  Map<String, dynamic> toJson() =>
      {'columnId': columnId, 'columnName': columnName, 'columnAge': columnAge};
}
