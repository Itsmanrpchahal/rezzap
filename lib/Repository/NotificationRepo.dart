import 'package:rezzap/Models/Notification.dart';
import 'package:rezzap/Network%20Calls/ApiBaseHelper.dart';

class NotificationRepo {
  ApiBaseHelper _helper = ApiBaseHelper();
  static final getNotificationUrl = "notifications";
  static final decAccUrl = "supporter/accept-decline-invite";
  static final clearAllUrl = "notifications/clear-all";
  static final deleteSingleNotifUrl = "notification/";

  //GET ALL NOTIFICATIONS
  Future<List<Notif>> getUserNotifications() async {
    final response = await _helper.get(getNotificationUrl);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => Notif.fromJson(d)).toList();
  }

  //STATUS ACCEPT OR DECLINE
  Future<bool> accpetOrDeclineRequest(String toUser, String statusType) async {
    final response = await _helper
        .post(decAccUrl, {"to_user": toUser, "status_type": statusType});
    print(response);
    return true;
  }

  //DELETE ALL NOTIFICATIONS
  Future<bool> deleteAllNotifications() async {
    final response = await _helper.delete(clearAllUrl);
    print(response);
    return true;
  }

  //DELETE SINGLE NOTIFICATIONS
  Future<bool> deleteSingleNotifications(String id) async {
    final response = await _helper.delete(deleteSingleNotifUrl + id);
    print(response);
    return true;
  }
}
