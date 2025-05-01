// Run me with `dart main.dart;`

import 'dart:io';

void main() {
  final rcFiData = loadFile('./fi_names_runtime_config.tsv');
  final dbFiData = loadFile('./fi_names_db.tsv');

  final rcIds = rcFiData.keys.toList();
  rcIds.sort((String a, String b) => a.compareTo(b));

  final dbIds = dbFiData.keys.toList();
  dbIds.sort((String a, String b) => a.compareTo(b));

  final nonExistingInDb = findNotExisting(rcIds, dbFiData);
  final nonExistingInRc = findNotExisting(dbIds, rcFiData);

  if (nonExistingInDb.isNotEmpty) {
    print('The following IDs are in RC but not in DB:');
    print('----------------------------------------');
    for (final id in nonExistingInDb) {
      print('RC: $id="${rcFiData[id]}"');
    }
  } else {
    print('All IDs in RC are also in DB.');
  }
  print('');

  if (nonExistingInRc.isNotEmpty) {
    print('The following IDs are in DB but not in RC:');
    print('----------------------------------------');
    for (final id in nonExistingInRc) {
      print('DB: $id="${dbFiData[id]}"');
    }
  } else {
    print('All IDs in DB are also in RC.');
  }
  print('');

  final List<String> differentInDb = [];
  for (final id in rcIds) {
    if (!dbFiData.containsKey(id)) {
      continue;
    }

    final rcName = rcFiData[id] ?? '';
    final dbName = dbFiData[id] ?? '';
    if (rcName.toLowerCase() != dbName.toLowerCase()) {
      differentInDb.add(id);
    }
  }

  if (differentInDb.isNotEmpty) {
    print('The following names in RC are different than the names in DB:');
    print('----------------------------------------');
    for (final id in differentInDb) {
      print('RC: $id="${rcFiData[id]}", DB: "${dbFiData[id]}"');
    }
  } else {
    print('All FI names in RC match those in the DB.');
  }
  print('');
}

/// Returns a list [ids] that do not exist in [data]
List<String> findNotExisting(List<String> ids, Map<String, String> data) {
  final List<String> res = [];
  for (final id in ids) {
    if (!data.keys.contains(id)) {
      res.add(id);
    }
  }
  return res;
}

/// Load tab separated file with 2 columns as a map
Map<String, String> loadFile(String filePath) {
  final fileLines = File(filePath).readAsLinesSync();
  if (fileLines.length < 2) {
    return {};
  }

  final hdr = fileLines[0].split('\t');
  final idxId = hdr.indexOf('BankIdentifier');
  final nameId = hdr.indexOf('Name');

  final fis = fileLines.skip(1).map((line) {
    final values = line.split('\t');
    return (values.length >= 2) ? (id: values[idxId].toUpperCase().trim(), name: values[nameId].trim()) : null;
  }).where((line) => line != null);

  final res = {for (var fi in fis) fi!.id: fi.name};
  return res;
}
