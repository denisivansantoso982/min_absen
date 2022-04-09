class AgendaData {
  AgendaData({
    required this.uid,
    required this.agendaName,
    required this.agendaDetail,
    required this.agendaStartAt,
    required this.agendaEndAt,
  });

  String uid;
  String agendaName;
  String agendaDetail;
  DateTime agendaStartAt;
  DateTime agendaEndAt;
}