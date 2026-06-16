enum TaskStatusFilter {
  all,
  pending,
  completed,
}

extension TaskStatusFilterExtension on TaskStatusFilter {
  String get apiValue {
    switch (this) {
      case TaskStatusFilter.all:
        return 'All';
      case TaskStatusFilter.pending:
        return 'Pending';
      case TaskStatusFilter.completed:
        return 'Completed';
    }
  }

  String get label {
    switch (this) {
      case TaskStatusFilter.all:
        return 'Todas';
      case TaskStatusFilter.pending:
        return 'Pendentes';
      case TaskStatusFilter.completed:
        return 'Concluídas';
    }
  }
}