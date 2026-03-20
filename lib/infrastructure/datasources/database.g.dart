// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<
    ReceivedNearbyMessage<NearbyMessageContent>,
    String
  >
  messageData =
      GeneratedColumn<String>(
        'message_data',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ReceivedNearbyMessage<NearbyMessageContent>>(
        $MessagesTable.$convertermessageData,
      );
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<String> chatId = GeneratedColumn<String>(
    'chat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, messageData, chatId, receivedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Message> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chat_id')) {
      context.handle(
        _chatIdMeta,
        chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      messageData: $MessagesTable.$convertermessageData.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}message_data'],
        )!,
      ),
      chatId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chat_id'],
      )!,
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }

  static TypeConverter<ReceivedNearbyMessage<NearbyMessageContent>, String>
  $convertermessageData = NearbyMessageConverter();
}

class Message extends DataClass implements Insertable<Message> {
  final int id;
  final ReceivedNearbyMessage<NearbyMessageContent> messageData;
  final String chatId;
  final DateTime receivedAt;
  const Message({
    required this.id,
    required this.messageData,
    required this.chatId,
    required this.receivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['message_data'] = Variable<String>(
        $MessagesTable.$convertermessageData.toSql(messageData),
      );
    }
    map['chat_id'] = Variable<String>(chatId);
    map['received_at'] = Variable<DateTime>(receivedAt);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      messageData: Value(messageData),
      chatId: Value(chatId),
      receivedAt: Value(receivedAt),
    );
  }

  factory Message.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      id: serializer.fromJson<int>(json['id']),
      messageData: serializer
          .fromJson<ReceivedNearbyMessage<NearbyMessageContent>>(
            json['messageData'],
          ),
      chatId: serializer.fromJson<String>(json['chatId']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'messageData': serializer
          .toJson<ReceivedNearbyMessage<NearbyMessageContent>>(messageData),
      'chatId': serializer.toJson<String>(chatId),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
    };
  }

  Message copyWith({
    int? id,
    ReceivedNearbyMessage<NearbyMessageContent>? messageData,
    String? chatId,
    DateTime? receivedAt,
  }) => Message(
    id: id ?? this.id,
    messageData: messageData ?? this.messageData,
    chatId: chatId ?? this.chatId,
    receivedAt: receivedAt ?? this.receivedAt,
  );
  Message copyWithCompanion(MessagesCompanion data) {
    return Message(
      id: data.id.present ? data.id.value : this.id,
      messageData: data.messageData.present
          ? data.messageData.value
          : this.messageData,
      chatId: data.chatId.present ? data.chatId.value : this.chatId,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('id: $id, ')
          ..write('messageData: $messageData, ')
          ..write('chatId: $chatId, ')
          ..write('receivedAt: $receivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, messageData, chatId, receivedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.id == this.id &&
          other.messageData == this.messageData &&
          other.chatId == this.chatId &&
          other.receivedAt == this.receivedAt);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<int> id;
  final Value<ReceivedNearbyMessage<NearbyMessageContent>> messageData;
  final Value<String> chatId;
  final Value<DateTime> receivedAt;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.messageData = const Value.absent(),
    this.chatId = const Value.absent(),
    this.receivedAt = const Value.absent(),
  });
  MessagesCompanion.insert({
    this.id = const Value.absent(),
    required ReceivedNearbyMessage<NearbyMessageContent> messageData,
    required String chatId,
    this.receivedAt = const Value.absent(),
  }) : messageData = Value(messageData),
       chatId = Value(chatId);
  static Insertable<Message> custom({
    Expression<int>? id,
    Expression<String>? messageData,
    Expression<String>? chatId,
    Expression<DateTime>? receivedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageData != null) 'message_data': messageData,
      if (chatId != null) 'chat_id': chatId,
      if (receivedAt != null) 'received_at': receivedAt,
    });
  }

  MessagesCompanion copyWith({
    Value<int>? id,
    Value<ReceivedNearbyMessage<NearbyMessageContent>>? messageData,
    Value<String>? chatId,
    Value<DateTime>? receivedAt,
  }) {
    return MessagesCompanion(
      id: id ?? this.id,
      messageData: messageData ?? this.messageData,
      chatId: chatId ?? this.chatId,
      receivedAt: receivedAt ?? this.receivedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (messageData.present) {
      map['message_data'] = Variable<String>(
        $MessagesTable.$convertermessageData.toSql(messageData.value),
      );
    }
    if (chatId.present) {
      map['chat_id'] = Variable<String>(chatId.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('messageData: $messageData, ')
          ..write('chatId: $chatId, ')
          ..write('receivedAt: $receivedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final MessagesDao messagesDao = MessagesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [messages];
}

typedef $$MessagesTableCreateCompanionBuilder =
    MessagesCompanion Function({
      Value<int> id,
      required ReceivedNearbyMessage<NearbyMessageContent> messageData,
      required String chatId,
      Value<DateTime> receivedAt,
    });
typedef $$MessagesTableUpdateCompanionBuilder =
    MessagesCompanion Function({
      Value<int> id,
      Value<ReceivedNearbyMessage<NearbyMessageContent>> messageData,
      Value<String> chatId,
      Value<DateTime> receivedAt,
    });

class $$MessagesTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    ReceivedNearbyMessage<NearbyMessageContent>,
    ReceivedNearbyMessage<NearbyMessageContent>,
    String
  >
  get messageData => $composableBuilder(
    column: $table.messageData,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get chatId => $composableBuilder(
    column: $table.chatId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageData => $composableBuilder(
    column: $table.messageData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chatId => $composableBuilder(
    column: $table.chatId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<
    ReceivedNearbyMessage<NearbyMessageContent>,
    String
  >
  get messageData => $composableBuilder(
    column: $table.messageData,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chatId =>
      $composableBuilder(column: $table.chatId, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );
}

class $$MessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessagesTable,
          Message,
          $$MessagesTableFilterComposer,
          $$MessagesTableOrderingComposer,
          $$MessagesTableAnnotationComposer,
          $$MessagesTableCreateCompanionBuilder,
          $$MessagesTableUpdateCompanionBuilder,
          (Message, BaseReferences<_$AppDatabase, $MessagesTable, Message>),
          Message,
          PrefetchHooks Function()
        > {
  $$MessagesTableTableManager(_$AppDatabase db, $MessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<ReceivedNearbyMessage<NearbyMessageContent>> messageData =
                    const Value.absent(),
                Value<String> chatId = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
              }) => MessagesCompanion(
                id: id,
                messageData: messageData,
                chatId: chatId,
                receivedAt: receivedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required ReceivedNearbyMessage<NearbyMessageContent>
                messageData,
                required String chatId,
                Value<DateTime> receivedAt = const Value.absent(),
              }) => MessagesCompanion.insert(
                id: id,
                messageData: messageData,
                chatId: chatId,
                receivedAt: receivedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessagesTable,
      Message,
      $$MessagesTableFilterComposer,
      $$MessagesTableOrderingComposer,
      $$MessagesTableAnnotationComposer,
      $$MessagesTableCreateCompanionBuilder,
      $$MessagesTableUpdateCompanionBuilder,
      (Message, BaseReferences<_$AppDatabase, $MessagesTable, Message>),
      Message,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
}
