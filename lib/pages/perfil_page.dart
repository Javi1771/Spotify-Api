import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spotify_api/pages/spotify_api.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> _artist = {};

  @override
  void initState() {
    super.initState();
    _loadArtist();
  }

  Future<void> _loadArtist() async {
    try {
      final artist = await SpotifyApi.getArtist('0OdUWJ0sBjDrqHygGUXeCF');
      setState(() {
        _artist = artist;
      });
    } catch (e) {
      print('Error al cargar el artista: $e');
    }
  }

  Future<void> _loadDifferentArtist() async {
    final artistIds = [
      '1rCIEwPp5OnXW0ornlSsRl',
      '2y8Jo9CKhJvtfeKOsYzRdT',
      '6vWDO969PvNqNYHIOW5v0m',
      '1HY2Jd0NmPuamShAr6KMms'
    ];
    final random = Random();
    final randomArtistId = artistIds[random.nextInt(artistIds.length)];

    try {
      final artist = await SpotifyApi.getArtist(randomArtistId);
      setState(() {
        _artist = artist;
      });
    } catch (e) {
      print('Error al cargar el artista: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: _artist == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        _artist.containsKey('images') &&
                                _artist['images'].isNotEmpty
                            ? _artist['images'][0]['url']
                            : '',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      _artist.containsKey('name')
                          ? _artist['name']
                          : 'Artist not found',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            _artist.containsKey('Popularidad')
                                ? _artist['popularity'].toString()
                                : '',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Popularidad',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            _artist.containsKey('Seguidores') &&
                                    _artist['followers'].containsKey('total')
                                ? _artist['followers']['total'].toString()
                                : '',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Seguidores',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: _loadDifferentArtist,
                      child: Text('Artista aleatorio'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
