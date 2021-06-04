// To parse this JSON data, do
//
//     final posts = postsFromJson(jsonString);

import 'dart:convert';

Posts postsFromJson(String str) => Posts.fromJson(json.decode(str));

String postsToJson(Posts data) => json.encode(data.toJson());

class Posts {
    Posts({
        this.sentences,
    });

    List<String> sentences;

    factory Posts.fromJson(Map<String, dynamic> json) => Posts(
        sentences: List<String>.from(json["Sentences"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "Sentences": List<dynamic>.from(sentences.map((x) => x)),
    };
}
