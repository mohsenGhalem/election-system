import 'package:get/get.dart';

import '../../../models/voter.dart';
import '../../../services/voter_service.dart';

class VoterController extends GetxController {
  final VoterService voterService;

  Rx<String> current_id = Rx('');

  VoterController({required this.voterService});

  Future<Voter?> getVoter({required String id}) async {
    Voter? voter;

    final response = await voterService.getVoter(id: id);
    response.fold(
      (l) => Get.snackbar(
        'Error',
        l.toString(),
        snackPosition: SnackPosition.BOTTOM,
      ),
      (r) => voter = r,
    );
    return voter;
  }

  Future<List<Voter>> getAllVoters() async {
    List<Voter> voters = [];

    final response = await voterService.getAllVoters();
    response.fold(
      (l) => Get.snackbar(
        'Error',
        l.toString(),
        snackPosition: SnackPosition.BOTTOM,
      ),
      (r) => voters = r,
    );
    return voters;
  }
}
