class DictionaryResponse {
  String? word;
  String? pronunciation;
  List<Definition>? definitions;

  DictionaryResponse({this.word, this.pronunciation, this.definitions});

  DictionaryResponse.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    pronunciation = json['pronunciation'];
    if (json['definitions'] != null) {
      definitions = <Definition>[];
      json['definitions'].forEach((v) {
        definitions!.add(Definition.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['word'] = word;
    data['pronunciation'] = pronunciation;
    if (definitions != null) {
      data['definitions'] = definitions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Definition {
  String? partOfSpeech;
  String? definition;
  String? example;
  List<String>? synonyms;
  List<String>? antonyms;

  Definition({
    this.partOfSpeech,
    this.definition,
    this.example,
    this.synonyms,
    this.antonyms,
  });

  Definition.fromJson(Map<String, dynamic> json) {
    partOfSpeech = json['partOfSpeech'];
    definition = json['definition'];
    example = json['example'];
    synonyms = json['synonyms']?.cast<String>();
    antonyms = json['antonyms']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['partOfSpeech'] = partOfSpeech;
    data['definition'] = definition;
    data['example'] = example;
    data['synonyms'] = synonyms;
    data['antonyms'] = antonyms;
    return data;
  }
}
