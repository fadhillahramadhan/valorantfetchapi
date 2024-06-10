import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Agent {
  final String uuid;
  final String displayName;
  final String description;
  final String developerName;
  final String displayIcon;
  final String displayIconSmall;
  final String bustPortrait;
  final String fullPortrait;
  final String fullPortraitV2;
  final String killfeedPortrait;
  final String background;
  final List<String> backgroundGradientColors;
  final String assetPath;
  final bool isFullPortraitRightFacing;
  final bool isPlayableCharacter;
  final bool isAvailableForTest;
  final bool isBaseContent;
  // final Role role;
  // final List<Abilities> abilities;

  Agent({
    required this.uuid,
    required this.displayName,
    required this.description,
    required this.developerName,
    required this.displayIcon,
    required this.displayIconSmall,
    required this.bustPortrait,
    required this.fullPortrait,
    required this.fullPortraitV2,
    required this.killfeedPortrait,
    required this.background,
    required this.backgroundGradientColors,
    required this.assetPath,
    required this.isFullPortraitRightFacing,
    required this.isPlayableCharacter,
    required this.isAvailableForTest,
    required this.isBaseContent,
    // required this.role,
    // required this.abilities,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      uuid: json['uuid'] as String,
      displayName: json['displayName'] as String,
      description: json['description'] as String,
      developerName: json['developerName'] as String? ?? '',
      displayIcon: json['displayIcon'] as String,
      displayIconSmall: json['displayIconSmall'] as String,
      bustPortrait: json['bustPortrait'] as String? ?? '',
      fullPortrait: json['fullPortrait'] as String? ?? '',
      fullPortraitV2: json['fullPortraitV2'] as String? ?? '',
      killfeedPortrait: json['killfeedPortrait'] as String? ?? '',
      background: json['background'] as String? ?? '',
      backgroundGradientColors:
          List<String>.from(json['backgroundGradientColors'] ?? []),
      assetPath: json['assetPath'] as String,
      isFullPortraitRightFacing: json['isFullPortraitRightFacing'] as bool,
      isPlayableCharacter: json['isPlayableCharacter'] as bool,
      isAvailableForTest: json['isAvailableForTest'] as bool,
      isBaseContent: json['isBaseContent'] as bool,
    );
  }
}

Future<List<Agent>> fetchAgents() async {
  final response =
      await http.get(Uri.parse('https://valorant-api.com/v1/agents'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);

    if (data['status'] == 200) {
      final List<dynamic> agentsData = data['data'];

      return agentsData.map((agent) => Agent.fromJson(agent)).toList();
    } else {
      throw Exception('Failed to load agents: Invalid status');
    }
  } else {
    throw Exception('Failed to load agents');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Agent>> futureAgents;

  @override
  void initState() {
    super.initState();
    futureAgents = fetchAgents();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Agents List'),
        ),
        body: Center(
          child: FutureBuilder<List<Agent>>(
            future: futureAgents,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No agents found');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final agent = snapshot.data![index];
                    return ListTile(
                      leading: Image.network(agent.displayIconSmall),
                      title: Text(agent.displayName),
                      subtitle: Text(agent.description),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

void main() => runApp(const MyApp());
