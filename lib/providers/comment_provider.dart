import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comment.dart';
import '../services/storage.dart';

final commentProvider = StateNotifierProvider<CommentNotifier, List<Comment>>((ref) {
  return CommentNotifier();
});

class CommentNotifier extends StateNotifier<List<Comment>> {
  final StorageService _storage = StorageService();

  CommentNotifier() : super([]) {
    _loadComments();
  }

  Future<void> _loadComments() async {
    state = _storage.getAllComments();
  }

  Future<void> addComment(Comment comment) async {
    await _storage.saveComment(comment);
    state = [...state, comment];
  }

  Future<void> updateComment(Comment comment) async {
    await _storage.saveComment(comment);
    state = [
      for (final c in state)
        if (c.id == comment.id) comment else c
    ];
  }

  Future<void> deleteComment(String commentId) async {
    await _storage.deleteComment(commentId);
    state = state.where((c) => c.id != commentId).toList();
  }

  List<Comment> getCommentsByTask(String taskId) {
    return state.where((c) => c.taskId == taskId).toList();
  }
}
