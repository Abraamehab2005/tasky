enum TaskItemActionsEnam {
  markAsDone(name: 'Done | UnDone'),
  edit(name: "Edit"),
  delete(name: 'Delete'),
  ;

  final String name;
  const TaskItemActionsEnam({required this.name});
}
