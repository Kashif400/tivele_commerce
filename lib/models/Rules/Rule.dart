class Rule {
  String? name;
  String? value;
  String? id;

  Rule({this.name, this.value, this.id});

  Rule.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    data['id'] = this.id;
    return data;
  }
}
