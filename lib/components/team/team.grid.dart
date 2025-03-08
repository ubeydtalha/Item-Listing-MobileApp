import 'package:flutter/material.dart';

import 'package:flutter_application_3/models/team.dart';
import 'package:flutter_application_3/pages/team/team.edit.dart';
import 'package:flutter_application_3/pages/team/team.profile.dart';



class TeamPreview extends StatelessWidget {
  final Team team;

  const TeamPreview({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => TeamProfilePage(team: team)),
        ),
        onDoubleTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => EditTeamPage(team: team)),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: team.getImage(
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
            ),
            Positioned.directional(
              bottom:
                  Directionality.of(context) == TextDirection.ltr ? 0 : null,
              textDirection: Directionality.of(context),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Text(
                  team.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
