class AgendaData {
  AgendaData({
    required this.uid,
    required this.agendaName,
    required this.agendaDetail,
    required this.agendaStartAt,
    required this.agendaEndAt,
    required this.isActive,
  });

  String uid;
  String agendaName;
  String agendaDetail;
  DateTime agendaStartAt;
  DateTime agendaEndAt;
  bool isActive;
}