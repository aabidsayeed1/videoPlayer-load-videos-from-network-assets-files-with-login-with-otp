// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, prefer_const_declarations

import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import '../widgets/navigation-drawer.dart';

List<String> videos = [
  'https://filesamples.com/samples/video/mp4/sample_640x360.mp4',
  'https://www.sample-videos.com/video123/mp4/360/big_buck_bunny_360p_10mb.mp4',
  'https://download.samplelib.com/mp4/sample-5s.mp4',
  'https://www.appsloveworld.com/wp-content/uploads/2018/10/Sample-Videos-Mp425.mp4',
];

List<String> downloaded = [];

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  static var index = 0;
  var filevideo =
      '/storage/emulated/0/Android/data/com.example.musicplayer/files/download';
  File file = File(
      '/storage/emulated/0/Android/data/com.example.musicplayer/files/download$index');

  VideoPlayerController? controller;
  int progress = 0;

  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort!.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });

      print(progress);
    });

    FlutterDownloader.registerCallback(downloadingCallback);
//from files
    // if (downloaded.isNotEmpty) {
    //   controller = VideoPlayerController.file(file)
    //     ..addListener(() => setState(() {}))
    //     ..setLooping(true)
    //     ..initialize().then((_) => controller!.play());
    // }
//form network
    // else {
    controller = VideoPlayerController.network(videos[index])
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => controller!.play());
    // }
  }

  void videoFile() async {
    controller = await VideoPlayerController.file(file)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => controller!.play());
  }

  void next() async {
    controller = await VideoPlayerController.network(videos[index])
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => controller!.play());
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = controller!.value.volume == 0;
    final padding = EdgeInsets.symmetric(horizontal: 20);

    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        drawer: NavigatorDrawer(),
        body: Builder(builder: (context) {
          return Container(
            width: size.width * 2,
            child: Column(
              children: [
                Container(
                  height: size.width * 0.55,
                  width: size.width,
                  child: Stack(
                    children: [
                      VideoPlayerWidget(controller1: controller),
                      SizedBox(height: 20),
                      Positioned(
                          width: size.width * 0.65,
                          left: 66,
                          bottom: 50,
                          child: VideoProgressIndicator(controller!,
                              colors: VideoProgressColors(
                                playedColor: Colors.green,
                              ),
                              allowScrubbing: true)),
                      if (controller != null && controller!.value.isInitialized)
                        Positioned(
                          bottom: 5,
                          left: 48,
                          child: SizedBox(
                            width: size.width,
                            child: Row(
                              children: [
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Duration currentPosition =
                                          controller!.value.position;
                                      Duration targetPosition =
                                          currentPosition -
                                              Duration(seconds: 3);

                                      controller!.seekTo(targetPosition);
                                      Fluttertoast.showToast(msg: 'back 3 sec');
                                    },
                                    icon: Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Colors.white,
                                    )),
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Duration currentPosition =
                                          controller!.value.position;
                                      Duration targetPosition =
                                          currentPosition +
                                              Duration(seconds: 3);

                                      controller!.seekTo(targetPosition);
                                      Fluttertoast.showToast(msg: 'skip 3 sec');
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    )),
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () =>
                                        controller!.setVolume(isMuted ? 1 : 0),
                                    icon: Icon(
                                      isMuted
                                          ? Icons.volume_mute
                                          : Icons.volume_up,
                                      color: Colors.white,
                                    )),
                                SizedBox(
                                  width: 70,
                                ),
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.settings,
                                      color: Colors.white,
                                    )),
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.fullscreen,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      Positioned(
                        left: 20,
                        bottom: 20,
                        child: GestureDetector(
                            onTap: () => controller!.value.isPlaying
                                ? controller!.pause()
                                : controller!.play(),
                            child: buildPlay()),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                child: Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 30,
                                )),
                            Container(
                              width: size.width * 0.11,
                              height: size.height * 0.05,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://media-exp1.licdn.com/dms/image/C4D03AQH5PFPH4odMIg/profile-displayphoto-shrink_200_200/0/1648738453286?e=1655337600&v=beta&t=GitFwAttUA3Np9--H9Ty0kI9EgHmXdojdJ8JnFr5qjI')),
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            setState(() {
                              if (index == videos.length - videos.length) {
                                Fluttertoast.showToast(msg: 'no more videos');
                              } else {
                                controller!.pause();
                                index--;
                                // if (downloaded.isNotEmpty) {
                                //   videoFile();
                                // }
                                next();
                              }
                            });
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                          )),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final status = await Permission.storage.request();
                        if (status.isGranted) {
                          final externalDir =
                              await getExternalStorageDirectory();
                          final id = await FlutterDownloader.enqueue(
                            url: videos[index],
                            savedDir: externalDir!.path,
                            fileName: 'download$index',
                            showNotification: true,
                            openFileFromNotification: false,
                          );
                        } else {
                          Fluttertoast.showToast(msg: 'Permission denied');
                        }

                        // downloaded.add("$filevideo$index");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.download,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Download',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            setState(() {
                              if (index == videos.length - 1) {
                                Fluttertoast.showToast(msg: 'no more videos');
                              } else {
                                controller!.pause();
                                index++;

                                next();
                              }
                            });
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                          )),
                    ),
                  ],
                ),
                // Text(
                //   "$progress",
                //   style: TextStyle(fontSize: 20),
                // ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget buildPlay() => controller!.value.isPlaying
      ? Icon(
          Icons.pause,
          color: Colors.white,
          size: 40,
        )
      : Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 40,
        );
}

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController? controller1;
  const VideoPlayerWidget({
    Key? key,
    required this.controller1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller1 != null && controller1!.value.isInitialized
        ? Container(alignment: Alignment.topCenter, child: buildVideo())
        : SizedBox(
            height: 300, child: Center(child: CircularProgressIndicator()));
  }

  Widget buildVideo() => buildVideoPlayer();
  Widget buildVideoPlayer() => AspectRatio(
      aspectRatio: controller1!.value.aspectRatio,
      child: VideoPlayer(controller1!));
}
