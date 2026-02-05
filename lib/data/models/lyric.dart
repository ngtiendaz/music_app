class Lyric {
  List<Sentence>? sentences;
  String? file;

  Lyric({this.sentences, this.file});

  factory Lyric.fromJson(Map<String, dynamic> json) {
    return Lyric(
      sentences: json['sentences'] != null
          ? (json['sentences'] as List).map((i) => Sentence.fromJson(i)).toList()
          : [],
      file: json['file'],
    );
  }
}

class Sentence {
  List<Word>? words;

  Sentence({this.words});

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      words: json['words'] != null
          ? (json['words'] as List).map((i) => Word.fromJson(i)).toList()
          : [],
    );
  }

  // Hàm phụ trợ để lấy thời gian bắt đầu của cả câu (dựa vào từ đầu tiên)
  int get startTime => words != null && words!.isNotEmpty ? words!.first.startTime ?? 0 : 0;
  
  // Hàm phụ trợ để nối các từ thành 1 câu hoàn chỉnh
  String get content => words?.map((e) => e.data).join(' ') ?? "";
}

class Word {
  int? startTime;
  int? endTime;
  String? data;

  Word({this.startTime, this.endTime, this.data});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      startTime: json['startTime'],
      endTime: json['endTime'],
      data: json['data'],
    );
  }
}