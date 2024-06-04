import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';

class OrphanagesPage extends StatefulWidget {
  @override
  _OrphanagesPageState createState() => _OrphanagesPageState();
}

class _OrphanagesPageState extends State<OrphanagesPage> {
  
  final List<Map<String, String>> mediaItems = [
    {'type': 'image', 'path': 'assets/images/orphanage1.jpg'},
    {'type': 'image', 'path': 'assets/images/orphanage2.jpg'},
    {'type': 'image', 'path': 'assets/images/orphanage3.jpg'},
    {'type': 'video', 'path': 'assets/videos/orphanage1.mp4'},
    {'type': 'video', 'path': 'assets/videos/orphanage2.mp4'},
  ];

  List<VideoPlayerController> _videoControllers = [];

  @override
  void initState() {
    super.initState();
    _initializeVideoControllers();
  }

  void _initializeVideoControllers() {
    for (var item in mediaItems) {
      if (item['type'] == 'video') {
        VideoPlayerController controller =
            VideoPlayerController.asset(item['path']!)
              ..initialize().then((_) {
                setState(() {});
              });
        _videoControllers.add(controller);
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 250.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlayInterval: Duration(seconds: 3),
      ),
      items: mediaItems.map((item) {
        if (item['type'] == 'image') {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage(item['path']!),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        } else if (item['type'] == 'video') {
          int index = mediaItems.indexOf(item);
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: _videoControllers[index - 3].value.isInitialized
                    ? AspectRatio(
                        aspectRatio:
                            _videoControllers[index - 3].value.aspectRatio,
                        child: VideoPlayer(_videoControllers[index - 3]),
                      )
                    : Center(child: CircularProgressIndicator()),
              );
            },
          );
        } else {
          return Container();
        }
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orphanages'),
      ),
      body: Column(
        children: [
          _buildCarousel(),
          // Ajoutez d'autres widgets pour le contenu de la page ici
        ],
      ),
    );
  }
}
