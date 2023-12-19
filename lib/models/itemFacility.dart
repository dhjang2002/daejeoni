// ignore_for_file: file_names, non_constant_identifier_names, prefer_typing_uninitialized_variables
class FacilityItem {
  String ID;
  String Label;
  String image_url;
  FacilityItem({
    this.ID = "0",
    this.image_url = "",
    this.Label = "",
  });

  @override
  String toString(){
    return 'FacilityItem {'
        'ID:$ID, '
        'Label:$Label, '
        ' }';
  }

  static List<FacilityItem> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return FacilityItem.fromJson(data);
    }).toList();
  }

  factory FacilityItem.fromJson(Map<String, dynamic> jdata)
  {
    return FacilityItem(
      ID: jdata['amenity_oid'],
      Label: jdata['amenity_title'],
      image_url: jdata['image'],
    );
  }
}