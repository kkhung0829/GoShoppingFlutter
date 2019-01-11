import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dropbox_state.g.dart';

@JsonSerializable()
@immutable
class DropboxState {
  final String accessToken;

  DropboxState({
    this.accessToken,
  });

  DropboxState copyWith({
    String accessToken = '',
  }) => DropboxState(
    accessToken: accessToken ?? this.accessToken,
  );

  factory DropboxState.fromJson(Map<String, dynamic> json) => _$DropboxStateFromJson(json);
  Map<String, dynamic> toJson() => _$DropboxStateToJson(this);
}