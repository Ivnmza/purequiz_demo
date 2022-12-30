// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetTestCollection on Isar {
  IsarCollection<Test> get tests => this.collection();
}

const TestSchema = CollectionSchema(
  name: r'Test',
  id: -5479267249076327074,
  properties: {
    r'testTitle': PropertySchema(
      id: 0,
      name: r'testTitle',
      type: IsarType.string,
    )
  },
  estimateSize: _testEstimateSize,
  serialize: _testSerialize,
  deserialize: _testDeserialize,
  deserializeProp: _testDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _testGetId,
  getLinks: _testGetLinks,
  attach: _testAttach,
  version: '3.0.5',
);

int _testEstimateSize(
  Test object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.testTitle.length * 3;
  return bytesCount;
}

void _testSerialize(
  Test object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.testTitle);
}

Test _testDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Test();
  object.id = id;
  object.testTitle = reader.readString(offsets[0]);
  return object;
}

P _testDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _testGetId(Test object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _testGetLinks(Test object) {
  return [];
}

void _testAttach(IsarCollection<dynamic> col, Id id, Test object) {
  object.id = id;
}

extension TestQueryWhereSort on QueryBuilder<Test, Test, QWhere> {
  QueryBuilder<Test, Test, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TestQueryWhere on QueryBuilder<Test, Test, QWhereClause> {
  QueryBuilder<Test, Test, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Test, Test, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Test, Test, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Test, Test, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TestQueryFilter on QueryBuilder<Test, Test, QFilterCondition> {
  QueryBuilder<Test, Test, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> testTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'testTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> testTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'testTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> testTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'testTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> testTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'testTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> testTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'testTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> testTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'testTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> testTitleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'testTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> testTitleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'testTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> testTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'testTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> testTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'testTitle',
        value: '',
      ));
    });
  }
}

extension TestQueryObject on QueryBuilder<Test, Test, QFilterCondition> {}

extension TestQueryLinks on QueryBuilder<Test, Test, QFilterCondition> {}

extension TestQuerySortBy on QueryBuilder<Test, Test, QSortBy> {
  QueryBuilder<Test, Test, QAfterSortBy> sortByTestTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testTitle', Sort.asc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> sortByTestTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testTitle', Sort.desc);
    });
  }
}

extension TestQuerySortThenBy on QueryBuilder<Test, Test, QSortThenBy> {
  QueryBuilder<Test, Test, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> thenByTestTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testTitle', Sort.asc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> thenByTestTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testTitle', Sort.desc);
    });
  }
}

extension TestQueryWhereDistinct on QueryBuilder<Test, Test, QDistinct> {
  QueryBuilder<Test, Test, QDistinct> distinctByTestTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'testTitle', caseSensitive: caseSensitive);
    });
  }
}

extension TestQueryProperty on QueryBuilder<Test, Test, QQueryProperty> {
  QueryBuilder<Test, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Test, String, QQueryOperations> testTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'testTitle');
    });
  }
}
