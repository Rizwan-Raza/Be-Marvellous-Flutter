class CharacterDetail {
  String link;
  String durability;
  String energy;
  String fightingSkills;
  String intelligence;
  String speed;
  String strength;
  String height;
  String weight;
  String gender;
  String eyes;
  String hair;
  String universe;
  String otherAliases;
  String education;
  String placeOfOrigin;
  String identity;
  String knownRelatives;
  String powers;

  CharacterDetail(
      {this.link,
      this.durability,
      this.energy,
      this.fightingSkills,
      this.intelligence,
      this.speed,
      this.strength,
      this.height,
      this.weight,
      this.eyes,
      this.hair,
      this.universe,
      this.otherAliases,
      this.education,
      this.placeOfOrigin,
      this.identity,
      this.knownRelatives,
      this.powers});

  CharacterDetail.fromMap(Map<dynamic, dynamic> map)
      : link = map['link'],
        durability = map['durability'],
        energy = map['energy'],
        fightingSkills = map['fighting_skills'],
        intelligence = map['intelligence'],
        speed = map['speed'],
        strength = map['strength'],
        height = map['height'],
        weight = map['weight'],
        gender = map['gender'],
        eyes = map['eyes'],
        hair = map['hair'],
        universe = map['universe'],
        otherAliases = map['other_aliases'],
        education = map['education'],
        placeOfOrigin = map['place_of_origin'],
        identity = map['identity'],
        knownRelatives = map['known_relatives'],
        powers = map['powers'];

  Map<String, String> toJson() {
    return {
      "link": link,
      "durability": durability,
      "energy": energy,
      "fighting_skills": fightingSkills,
      "intelligence": intelligence,
      "speed": speed,
      "strength": strength,
      "height": height,
      "weight": weight,
      "gender": gender,
      "eyes": eyes,
      "hair": hair,
      "universe": universe,
      "other_aliases": otherAliases,
      "education": education,
      "place_of_origin": placeOfOrigin,
      "identity": identity,
      "known_relatives": knownRelatives,
      "powers": powers
    };
  }
}
