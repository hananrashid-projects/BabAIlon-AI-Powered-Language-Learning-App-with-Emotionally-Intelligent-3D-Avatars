import 'package:babellion/models/Player.dart';
import 'package:babellion/providers/player_scores_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScoreboardScreen extends ConsumerWidget {
  const ScoreboardScreen({super.key});

  Color getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color.fromARGB(255, 224, 194, 158);
      case 2:
        return const Color.fromARGB(255, 224, 194, 158);
      case 3:
        return const Color.fromARGB(255, 224, 194, 158);
      default:
        return const Color.fromARGB(255, 224, 194, 158);
    }
  }

  Widget buildTopPlayer(int rank, String? name, int? score) {
    if (name == null || score == null) {
      return Container(); // Return an empty container if the data is null
    }
    return Column(
      children: [
        const SizedBox(height: 10),
        // Display rank above the image
        Text(
          "#$rank",
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        Stack(
          clipBehavior: Clip.none, // Prevent clipping of the ribbon image
          alignment: Alignment.center,
          children: [
            // Rank color circle background
            CircleAvatar(
              radius: rank == 1 ? 60 : 50,
              backgroundColor: getRankColor(rank),
            ),
            // Player image circle
            Container(
              width: rank == 1 ? 100 : 90,
              height: rank == 1 ? 100 : 90,
              decoration: BoxDecoration(
                color: Colors.white, // White background for the player image
                borderRadius: BorderRadius.circular(50),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/player.png',
                  width: rank == 1 ? 90 : 80,
                  height: rank == 1 ? 90 : 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (rank == 1)
              Positioned(
                top: -1,
                child: Image.asset(
                  'assets/images/round_ribbon.png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        // Display name and score
        Text(
          name,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          "$score",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  Widget buildRegularPlayer(int rank, String? name, int? score) {
    if (name == null || score == null) {
      return Container(); // Return an empty container if the data is null
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 170, 144, 125),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: -39,
                  left: -10,
                  child: Image.asset(
                    'assets/images/rank.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: -20,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      "#$rank",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 106, 83, 68),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/player.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const Spacer(),
          // Player score
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "$score",
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(scoreboardProvider);

    // Check if the players list is null or empty
    if (players == null || players.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    List<Player> topThree = players.take(3).toList();
    List<Player> rest = players.skip(3).toList();

    return Scaffold(
      backgroundColor: Colors.brown, // Set background color to brown
      body: Column(
        children: [
          // Scoreboard Text at the top
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Scoreboard',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color:
                    Colors.white, // Text color updated to white for visibility
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (topThree.length > 1)
                buildTopPlayer(2, topThree[1].fullName, topThree[1].score),
              if (topThree.isNotEmpty)
                buildTopPlayer(1, topThree[0].fullName, topThree[0].score),
              if (topThree.length > 2)
                buildTopPlayer(3, topThree[2].fullName, topThree[2].score),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount:
                  rest.isNotEmpty ? rest.length : 0, // Add a null/empty check
              itemBuilder: (context, index) {
                int rank = index + 4;
                return buildRegularPlayer(
                    rank,
                    rest[index]?.fullName ?? "Unknown",
                    rest[index]?.score ?? 0);
              },
            ),
          ),
        ],
      ),
    );
  }
}
