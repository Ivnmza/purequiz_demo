import 'package:isar/isar.dart';

part 'test.g.dart';

@Collection()
class Test{
  Id id = Isar.autoIncrement;

  late String testTitle;

}