class CloudStorageException implements Exception {
  const CloudStorageException();
}

//C in CRUD
class CouldNoteCreateNotesException extends CloudStorageException {}

//R in CRUD
class CouldNoteGetNotesException extends CloudStorageException {}

//U in CRUD
class CouldNotUpdateNotesException extends CloudStorageException {}

//D in CRUD
class CouldNotDeleteNotesException extends CloudStorageException {}
