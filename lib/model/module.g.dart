// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetModuleCollection on Isar {
  IsarCollection<Module> get modules => this.collection();
}

const ModuleSchema = CollectionSchema(
  name: r'Module',
  id: -2335926089013615123,
  properties: {
    r'moduleTitle': PropertySchema(
      id: 0,
      name: r'moduleTitle',
      type: IsarType.string,
    )
  },
  estimateSize: _moduleEstimateSize,
  serialize: _moduleSerialize,
  deserialize: _moduleDeserialize,
  deserializeProp: _moduleDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'quizzes': LinkSchema(
      id: 7624285877009910838,
      name: r'quizzes',
      target: r'Quiz',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _moduleGetId,
  getLinks: _moduleGetLinks,
  attach: _moduleAttach,
  version: '3.0.5',
);

int _moduleEstimateSize(
  Module object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.moduleTitle.length * 3;
  return bytesCount;
}

void _moduleSerialize(
  Module object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.moduleTitle);
}

Module _moduleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Module();
  object.id = id;
  object.moduleTitle = reader.readString(offsets[0]);
  return object;
}

P _moduleDeserializeProp<P>(
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

Id _moduleGetId(Module object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _moduleGetLinks(Module object) {
  return [object.quizzes];
}

void _moduleAttach(IsarCollection<dynamic> col, Id id, Module object) {
  object.id = id;
  object.quizzes.attach(col, col.isar.collection<Quiz>(), r'quizzes', id);
}

extension ModuleQueryWhereSort on QueryBuilder<Module, Module, QWhere> {
  QueryBuilder<Module, Module, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ModuleQueryWhere on QueryBuilder<Module, Module, QWhereClause> {
  QueryBuilder<Module, Module, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Module, Module, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Module, Module, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Module, Module, QAfterWhereClause> idBetween(
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

extension ModuleQueryFilter on QueryBuilder<Module, Module, QFilterCondition> {
  QueryBuilder<Module, Module, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Module, Module, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Module, Module, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Module, Module, QAfterFilterCondition> moduleTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moduleTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> moduleTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moduleTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> moduleTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moduleTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> moduleTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moduleTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> moduleTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'moduleTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> moduleTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'moduleTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> moduleTitleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'moduleTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> moduleTitleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'moduleTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> moduleTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moduleTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> moduleTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'moduleTitle',
        value: '',
      ));
    });
  }
}

extension ModuleQueryObject on QueryBuilder<Module, Module, QFilterCondition> {}

extension ModuleQueryLinks on QueryBuilder<Module, Module, QFilterCondition> {
  QueryBuilder<Module, Module, QAfterFilterCondition> quizzes(
      FilterQuery<Quiz> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'quizzes');
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> quizzesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'quizzes', length, true, length, true);
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> quizzesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'quizzes', 0, true, 0, true);
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> quizzesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'quizzes', 0, false, 999999, true);
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> quizzesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'quizzes', 0, true, length, include);
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> quizzesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'quizzes', length, include, 999999, true);
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> quizzesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'quizzes', lower, includeLower, upper, includeUpper);
    });
  }
}

extension ModuleQuerySortBy on QueryBuilder<Module, Module, QSortBy> {
  QueryBuilder<Module, Module, QAfterSortBy> sortByModuleTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moduleTitle', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByModuleTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moduleTitle', Sort.desc);
    });
  }
}

extension ModuleQuerySortThenBy on QueryBuilder<Module, Module, QSortThenBy> {
  QueryBuilder<Module, Module, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByModuleTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moduleTitle', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByModuleTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moduleTitle', Sort.desc);
    });
  }
}

extension ModuleQueryWhereDistinct on QueryBuilder<Module, Module, QDistinct> {
  QueryBuilder<Module, Module, QDistinct> distinctByModuleTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moduleTitle', caseSensitive: caseSensitive);
    });
  }
}

extension ModuleQueryProperty on QueryBuilder<Module, Module, QQueryProperty> {
  QueryBuilder<Module, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Module, String, QQueryOperations> moduleTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moduleTitle');
    });
  }
}
