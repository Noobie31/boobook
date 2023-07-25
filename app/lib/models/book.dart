import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_service/firestore_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:isbndb/book.dart' as isbn_db;

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
class Book with _$Book {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  factory Book({
    @Default("") String title,
    String? isbn,
    @Default("") String isbn13,
    @NullableTimestampConverter() DateTime? datePublished,
    String? publisher,
    int? pages,
    String? imageUrl,
    bool? isNewBook,
    String? synopsys,
    @Default([]) List<String?> authors,
    String? id,
    String? userId,
    @Default(1) int copies,
    @Default(true) isAvailable,
    @Default(0) int totalLoans,
    @Default(false) isFromisbNdb,
    @Default(false) isFromUnknownisbN,
    @Default(false) isMagazine,
    @Default(false) bool isArchived,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  factory Book.fromisbNdb(
    isbn_db.Book book, {
    required String id,
  }) =>
      Book(
        id: id,
        title: book.title.split("(")[0].trim(),
        isbn: book.isbn,
        isbn13: book.isbn13,
        datePublished: book.datePublished,
        publisher: book.publisher,
        pages: book.pages,
        imageUrl: book.image,
        synopsys: book.synopsys,
        authors: book.authors ?? [],
        isFromisbNdb: true,
      );

  factory Book.create({
    required String id,
  }) =>
      Book(
        id: id,
        isNewBook: true,
      );

  factory Book.fromUnknownisbN({
    required String id,
    required String isbn13,
  }) =>
      Book(
        id: id,
        isbn13: isbn13,
        isNewBook: true,
        isFromUnknownisbN: true,
      );
}

extension BookX on Book {
  String get subtitle {
    var elements = [];

    if (datePublished != null) {
      elements.add(DateFormat.y().format(datePublished!));
    }
    if (publisher != null) {
      elements.add(publisher);
    }
    return elements.isEmpty ? "" : elements.join(", ");
  }

  String get dashedisbN {
    if (isbn13.length == 13) {
      return isbn13.substring(0, 3) +
          "-" +
          isbn13.substring(3, 4) +
          "-" +
          isbn13.substring(4, 6) +
          "-" +
          isbn13.substring(6, 12) +
          "-" +
          isbn13.substring(12, 13);
    } else {
      return isbn13;
    }
  }
}
