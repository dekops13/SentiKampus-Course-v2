class DemoWeek {
  const DemoWeek({
    required this.week,
    required this.title,
    required this.level,
    required this.focus,
    required this.demoAction,
    required this.evidence,
    required this.capabilities,
  });

  final int week;
  final String title;
  final String level;
  final String focus;
  final String demoAction;
  final String evidence;
  final List<String> capabilities;

  bool has(String capability) => capabilities.contains(capability);
}

