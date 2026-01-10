import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/profile/models.dart';

void main() {
  group('UserProfile.fromJson', () {
    test('parses complete profile', () {
      final json = {
        'user_id': 'user-123',
        'username': 'alice',
        'avatar_id': 'avatar-456',
        'avatar_storage_path': 'avatars/alice.png',
      };
      final result = UserProfile.fromJson(
        json,
        avatarUrl: 'https://example.com/avatar.png',
        avatarVersion: 'v1',
      );

      expect(result.userId, 'user-123');
      expect(result.username, 'alice');
      expect(result.avatarId, 'avatar-456');
      expect(result.avatarStoragePath, 'avatars/alice.png');
      expect(result.avatarUrl, 'https://example.com/avatar.png');
      expect(result.avatarVersion, 'v1');
    });

    test('parses profile without optional fields', () {
      final json = {'user_id': 'user-123', 'username': 'bob'};
      final result = UserProfile.fromJson(json);

      expect(result.userId, 'user-123');
      expect(result.username, 'bob');
      expect(result.avatarId, isNull);
      expect(result.avatarStoragePath, isNull);
      expect(result.avatarUrl, isNull);
      expect(result.avatarVersion, isNull);
    });

    test('copyWith preserves values', () {
      final original = UserProfile.fromJson({
        'user_id': 'user-123',
        'username': 'alice',
        'avatar_id': 'avatar-456',
      });
      final updated = original.copyWith(username: 'alice_updated');

      expect(updated.userId, 'user-123');
      expect(updated.username, 'alice_updated');
      expect(updated.avatarId, 'avatar-456');
    });

    test('copyWith replaces values', () {
      final original = UserProfile.fromJson({
        'user_id': 'user-123',
        'username': 'alice',
      });
      final updated = original.copyWith(
        avatarUrl: 'https://new-avatar.png',
        avatarVersion: 'v2',
      );

      expect(updated.avatarUrl, 'https://new-avatar.png');
      expect(updated.avatarVersion, 'v2');
    });
  });

  group('ProfileAvatar.fromJson', () {
    test('parses complete avatar', () {
      final json = {
        'id': 'avatar-123',
        'storage_path': 'avatars/cat.png',
        'category': 'animal',
      };
      final result = ProfileAvatar.fromJson(
        json,
        imageUrl: 'https://example.com/cat.png',
      );

      expect(result.id, 'avatar-123');
      expect(result.storagePath, 'avatars/cat.png');
      expect(result.category, 'animal');
      expect(result.imageUrl, 'https://example.com/cat.png');
    });

    test('parses avatar without imageUrl', () {
      final json = {
        'id': 'avatar-123',
        'storage_path': 'avatars/dog.png',
        'category': 'animal',
      };
      final result = ProfileAvatar.fromJson(json);

      expect(result.id, 'avatar-123');
      expect(result.storagePath, 'avatars/dog.png');
      expect(result.category, 'animal');
      expect(result.imageUrl, isNull);
    });

    test('copyWith updates imageUrl', () {
      final original = ProfileAvatar.fromJson({
        'id': 'avatar-123',
        'storage_path': 'avatars/cat.png',
        'category': 'animal',
      });
      final updated = original.copyWith(imageUrl: 'https://new-url.png');

      expect(updated.id, 'avatar-123');
      expect(updated.storagePath, 'avatars/cat.png');
      expect(updated.imageUrl, 'https://new-url.png');
    });

    test('equatable compares all props', () {
      final avatar1 = ProfileAvatar.fromJson({
        'id': 'avatar-123',
        'storage_path': 'avatars/cat.png',
        'category': 'animal',
      });
      final avatar2 = ProfileAvatar.fromJson({
        'id': 'avatar-123',
        'storage_path': 'avatars/cat.png',
        'category': 'animal',
      });
      final avatar3 = ProfileAvatar.fromJson({
        'id': 'avatar-456',
        'storage_path': 'avatars/dog.png',
        'category': 'animal',
      });

      expect(avatar1, equals(avatar2));
      expect(avatar1, isNot(equals(avatar3)));
    });
  });
}
