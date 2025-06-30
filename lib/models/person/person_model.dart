import 'package:freezed_annotation/freezed_annotation.dart';

part 'person_model.freezed.dart';

part 'person_model.g.dart';

@freezed
abstract class Person with _$Person {
  const Person._();

  const factory Person({
    required String firstName,
    required String lastName,
    required int age,
}) = _Person;

  factory Person.fromJson(Map<String, Object?> json) => _$PersonFromJson(json);

  void printIt() {
    print('Hello World!');
  }
}