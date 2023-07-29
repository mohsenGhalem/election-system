import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/candidate.dart';
import '../models/election.dart';
import '../models/voter.dart';
import '../services/local_storage_service.dart';

class ElectionCotroller extends GetxController {
  LocalStorageService localStorageService = LocalStorageServiceImpl();
  Map<String, dynamic> user_data = {
    'user_id': '',
    'user_type': '',
    'id': '',
    'registred': false,
  };
  Future<Election?> getElection({required String id}) async {
    try {
      final client = Supabase.instance.client;
      final Map<String, dynamic> response = await client
          .from('elections')
          .select()
          .eq('election_id', id)
          .single();
      final Election election = Election.fromMap(response);

      await getUserData(election.election_id!);

      print(user_data);

      return election;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<bool> enrollCandidateInElection(
      String candidate_id, String election_id) async {
    try {
      await Supabase.instance.client.from('candidates_elections').insert(
        {
          'candidate_id': candidate_id,
          'election_id': election_id,
          'is_verified': 'pending'
        },
      );

      return true;
    } catch (e) {
      debugPrint('enrollCandidateInElection ERROR : $e');
      return false;
    }
  }

  Future<bool> enrollVoterInElection(
      String voter_id, String election_id) async {
    try {
      final client = Supabase.instance.client;

      final res = await client
          .from('voter_elections')
          .select('*', const FetchOptions(count: CountOption.exact))
          .eq('voter_id', voter_id)
          .eq('election_id', election_id);

      if (res.count < 1) {
        await Supabase.instance.client.from('voter_elections').insert(
          {
            'voter_id': voter_id,
            'election_id': election_id,
            'vote_cast': false,
          },
        );
      }

      return true;
    } catch (e) {
      debugPrint('enrollVoterInElection ERROR = $e');
      return false;
    }
  }

  getUserData(String election_id) async {
    bool userType = await localStorageService.isVoter();

    user_data['user_type'] = userType ? 'voter' : "candidate";

    if (user_data['user_type'] == 'voter') {
      Voter value = await localStorageService.getCurrentUserVoter();

      user_data['user_id'] = value.user_id;
      user_data['id'] = value.voter_id;
      final List<dynamic> data = await Supabase.instance.client
          .from('voter_elections')
          .select('vote_cast')
          .eq('voter_id', value.voter_id)
          .eq('election_id', election_id)
          .limit(1);

      user_data['registred'] = data.isEmpty ? false : data[0]['vote_cast'];
    } else {
      Candidate value = await localStorageService.getCurrentUserCandidate();

      user_data['user_id'] = value.user_id;
      user_data['id'] = value.candidate_id;
      final data = await Supabase.instance.client
          .from('candidates_elections')
          .select(
            '*',
            const FetchOptions(
              count: CountOption.exact,
            ),
          )
          .eq('candidate_id', value.candidate_id)
          .eq('election_id', election_id);

      if (data.count > 0) {
        user_data['registred'] = true;
      } else {
        user_data['registred'] = false;
      }
    }
  }

  Future<List<CandidateElectionVoteCount>> getVoteCount(
      {required String id}) async {
    try {
      final client = Supabase.instance.client;
      List<dynamic> candidates_ids =
          await client.from('candidates_elections').select('candidate_id');

      candidates_ids = candidates_ids.map((e) => e['candidate_id']).toList();
      //await client.from('candidates').select('*,votes(count(*) as vote_count)');
      List<dynamic> response = await client
          .from('candidates')
          .select('*, full_name,votes(*)')
          .in_('candidate_id', candidates_ids);
      List<CandidateElectionVoteCount> list = response.map(
        (item) {
          return CandidateElectionVoteCount(
              candidate_id: item['candidate_id'].toString(),
              user_id: item['user_id'],
              full_name: item['full_name'],
              birth_date: DateTime.parse(item['birth_date']),
              candidate_statement: item['candidate_statement'],
              candidate_image: item['candidate_image'],
              vote_count: (item['votes'] ?? 0).length);
        },
      ).toList();
      list.sort(
        (a, b) => b.vote_count.compareTo(a.vote_count),
      );
      return list;
    } catch (e) {
      debugPrint('getVoteCount ERROR = $e');
      return [];
    }
  }

  Future<List<Candidate>> getAcceptedCandidate(String election_id) async {
    try {
      final List<dynamic> data = await Supabase.instance.client
          .from('candidates_elections')
          .select('*,candidates(*)')
          .eq('is_verified', 'accepted')
          .eq('election_id', election_id);
      return data.map((e) => Candidate.fromMap(e['candidates'])).toList();
    } catch (e) {
      debugPrint('getAcceptedCandidate ERROR = $e');
      return [];
    }
  }

  Future<bool> voteForCandidate(
      String election_id, String candidate_id, String voter_id) async {
    try {
      final client = Supabase.instance.client;
      //insert vote
      await client.from('votes').insert(
        {
          'voter_id': voter_id,
          'election_id': election_id,
          'candidate_id': candidate_id,
          'vote_timestamp': DateTime.now().toIso8601String()
        },
      );
      //update vote cast for voter
      await client
          .from('voter_elections')
          .update({'vote_cast': true})
          .eq('voter_id', voter_id)
          .eq('election_id', election_id);
      return true;
    } catch (e) {
      debugPrint('voteForCandidate ERROR = $e');
      return false;
    }
  }
}
