import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:whatsapp_screen_clone/provider/chatProvider.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart' as audio;

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  DateTime currrentDate = DateTime.now();

  TextEditingController _textEditingController = TextEditingController();

  Future<void> loadChats() async {
    ChatProvider provider = Provider.of<ChatProvider>(context, listen: false);
    final String response =
        await rootBundle.loadString('assets/json/whatsapp_chat_modified.json');
    final data = json.decode(response);
    print(data);
    provider.changeChats(list: data);
  }

  @override
  void initState() {
    loadChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        // backgroundColor: Colors.black,
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        appBar(context: context),
        Expanded(child: Body(context: context))
      ],
    ));
  }

  Container bottomNavigation({required BuildContext context}) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.1,
      width: width,

      margin: EdgeInsets.only(left: width * 0.03),
      // color: Colors.red,

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: width * 0.73,
            height: height * 0.06,
            decoration: BoxDecoration(
                // color: Colors.red,
                color: Color.fromARGB(255, 31, 44, 52),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            padding: EdgeInsets.symmetric(horizontal: width * 0.03),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/smile.png",
                  color: Colors.white38,
                  height: 25,
                ),
                Container(
                  width: width * 0.45,
                  height: height * 0.05,
                  // color: Colors.blue,
                ),
                Expanded(
                    child: Container(
                  height: height * 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/attach-file.png",color: Colors.white38,height: 25,),
                          SizedBox(width: width*0.04,),
                          Image.asset("assets/camera.png",color: Colors.white38,height: 27,),
                        ],
                      ),
                ))
              ],
            ),
          ),
          SizedBox(
            width: width * 0.04,
          ),
          CircleAvatar(
            // backgroundColor: Colors.green,
            backgroundColor: Color.fromARGB(255, 32, 145, 79),
            radius: 30,
            child: Center(child: Image.asset("assets/mic.png",height: 28,),),
          )
        ],
      ),
    );
  }

  Container appBar({required BuildContext context}) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      // color: Colors.black,
      color: Color.fromARGB(255, 11, 20, 27),
      height: height * 0.14,
      width: width,

      padding: EdgeInsets.only(top: height * 0.06),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          SizedBox(
            width: width * 0.03,
          ),
          CircleAvatar(backgroundColor: Colors.white, radius: 20,backgroundImage: AssetImage("assets/icon/suchi.jpeg"),),
          SizedBox(
            width: width * 0.03,
          ),
          Text(
            "Ranjan",
            style: GoogleFonts.lato(color: Colors.white, fontSize: 20),
          )
        ],
      ),
    );
  }

  Container Body({required BuildContext context}) {
    ChatProvider provider = Provider.of<ChatProvider>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              "assets/bg.png",
            )),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: width,
            height: height * 0.74,
            // color: ColoPrs.yellowAccent,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: provider.chats.length,
              itemBuilder: (context, index) {
                Map map = provider.chats[index];

                // DateFormat dateFormat = DateFormat("dd/MM/yyyy");
                // DateTime parsedDate = dateFormat.parse(date);

                // bool underDate = parsedDate.isAtSameMomentAs(currrentDate);

                // if (!underDate) {
                //   currrentDate = parsedDate;
                // }

                // if (map["changed_date"]) {
                //   return dateContainer(context: context, date: date);
                // }

                if (map["message_type"] == "text") {
                  return textTile(
                    map: map,
                    context: context,
                  );
                }
                else if (map["message_type"] == "img") {
                  return imgTile(map: map, context: context);
                }
                else if (map["message_type"] == "video") {
                  return VideoPlayerScreen(
                    map: map,
                  );
                }
                else if (map["message_type"] == "sticker") {
                  return stickerTile(map: map, context: context);
                } else if (map["message_type"] == "audio") {
                  return AudioPlayerScreen(
                    map: map,
                  );
                }
                if (map["message_type"] == "voice") {
                  return VoiceAudioScreen(audioUrl: map["message_body"], map: map,);
                }
                else {
                  return Container();
                }
              },
            ),
          ),
          bottomNavigation(context: context)
        ],
      ),
    );
  }

  dateContainer({required BuildContext context, required String date}) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: width * 0.2,
          height: height * 0.05,
          color: Colors.amber,
          margin: EdgeInsets.only(bottom: 10),
        )
      ],
    );
  }

  textTile({
    required Map map,
    required BuildContext context,
  }) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var splitTime = map["timestamp"].toString().split(",");
    String date = splitTime[0];
    String time = splitTime[1];

    return Column(
      children: [
        map["changed_date"]
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // width: width * 0.2,
                    // height: height * 0.03,
                    margin: EdgeInsets.only(bottom: height * 0.01),
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03, vertical: height * 0.007),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 11, 20, 27),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        date,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              )
            : Container(),
        Align(
          alignment: map["is_suchi"] ? Alignment.topRight : Alignment.topLeft,
          child: Container(
            padding: EdgeInsets.symmetric(
                    vertical: height * 0.01, horizontal: width * 0.02)
                .copyWith(bottom: height * 0.0035),
            margin: map["is_suchi"]
                ? EdgeInsets.only(
                    bottom: height * 0.01,
                    left: width * 0.18,
                    right: width * 0.02)
                : EdgeInsets.only(
                    bottom: height * 0.01,
                    right: width * 0.18,
                    left: width * 0.02),
            decoration: BoxDecoration(
                color: map["is_suchi"]
                    ? Color.fromARGB(255, 32, 145, 79)
                    : Color.fromARGB(255, 31, 44, 52),
                borderRadius: map["is_suchi"]
                    ? BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))
                    : BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${map["message_body"]}           ",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  time,
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  imgTile({required Map map, required BuildContext context}) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var splitTime = map["timestamp"].toString().split(",");
    String date = splitTime[0];
    String time = splitTime[1];

    return Column(
      children: [
        map["changed_date"]
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // width: width * 0.2,
                    // height: height * 0.03,
                    margin: EdgeInsets.only(bottom: height * 0.01),
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03, vertical: height * 0.007),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 11, 20, 27),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        date,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              )
            : Container(),
        Align(
          alignment: map["is_suchi"] ? Alignment.topRight : Alignment.topLeft,
          child: Container(
            padding: EdgeInsets.symmetric(
                    vertical: height * 0.004, horizontal: width * 0.01)
                .copyWith(bottom: height * 0.0035),
            margin: map["is_suchi"]
                ? EdgeInsets.only(
                    bottom: height * 0.01,
                    left: width * 0.18,
                    right: width * 0.02)
                : EdgeInsets.only(
                    bottom: height * 0.01,
                    right: width * 0.18,
                    left: width * 0.02),
            decoration: BoxDecoration(
                color: map["is_suchi"]
                    ? Color.fromARGB(255, 32, 145, 79)
                    : Color.fromARGB(255, 31, 44, 52),
                borderRadius: map["is_suchi"]
                    ? BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))
                    : BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
            // child: Column(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     Image.network(
            //       map["message_body"],
            //       height: 200,
            //     ),
            //     Text(
            //       "11:26 am",
            //       style: TextStyle(color: Colors.white, fontSize: 10),
            //     ),
            //   ],
            // ),

            child: Container(
              padding:
                  EdgeInsets.only(right: width * 0.01, bottom: height * 0.005),
              height: height * 0.3,
              decoration: BoxDecoration(
                // color: Colors.red,
                image: DecorationImage(
                    image: NetworkImage(map["message_body"]),
                    fit: BoxFit.cover),
                borderRadius: map["is_suchi"]
                    ? BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))
                    : BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  time,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  stickerTile({required Map map, required BuildContext context})
  {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var splitTime = map["timestamp"].toString().split(",");
    String date = splitTime[0];
    String time = splitTime[1];

    return Align(
      alignment: map["is_suchi"] ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.symmetric(
                vertical: height * 0.004, horizontal: width * 0.01)
            .copyWith(bottom: height * 0.0035),
        margin: map["is_suchi"]
            ? EdgeInsets.only(
                bottom: height * 0.01, left: width * 0.18, right: width * 0.02)
            : EdgeInsets.only(
                bottom: height * 0.01, right: width * 0.18, left: width * 0.02),
        decoration: BoxDecoration(
            // color: map["is_suchi"]
            // ? Color.fromARGB(255, 32, 145, 79)
            // : Color.fromARGB(255, 31, 44, 52),
            borderRadius: map["is_suchi"]
                ? BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))
                : BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            map["changed_date"]
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  // width: width * 0.2,
                  // height: height * 0.03,
                  margin: EdgeInsets.only(bottom: height * 0.01),
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03, vertical: height * 0.007),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 11, 20, 27),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      date,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              ],
            )
                : Container(),
            Container(
              padding: EdgeInsets.only(right: width * 0.01, bottom: height * 0.005),
              height: height * 0.2,

              // child: Align(
              //   alignment: Alignment.bottomRight,
              //   child: Text(
              //     "11:26 am",
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 10,
              //         fontWeight: FontWeight.w700),
              //   ),
              // ),

              child: ExtendedImage.network(
                map["message_body"],
                cache: true,
                // fit: BoxFit.cover,
                mode: ExtendedImageMode.gesture,
              ),
            ),
            Text(
              time,
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final Map map;

  const VideoPlayerScreen({super.key, required this.map});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  bool isplaying = false;
  int tap = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the video controller
    _controller = VideoPlayerController.network(
      widget.map["message_body"],
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      }).catchError((error) {
        print('Video player initialization failed: $error');
      });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var splitTime = widget.map["timestamp"].toString().split(",");
    String date = splitTime[0];
    String time = splitTime[1];

    return Column(
      children: [
        widget.map["changed_date"]
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // width: width * 0.2,
                    // height: height * 0.03,
                    margin: EdgeInsets.only(bottom: height * 0.01),
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03, vertical: height * 0.007),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 11, 20, 27),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        date,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              )
            : Container(),
        Align(
          alignment:
              widget.map["is_suchi"] ? Alignment.topRight : Alignment.topLeft,
          child: Container(
            padding: EdgeInsets.symmetric(
                    vertical: height * 0.004, horizontal: width * 0.01)
                .copyWith(bottom: height * 0.0035),
            margin: widget.map["is_suchi"]
                ? EdgeInsets.only(
                    bottom: height * 0.01,
                    left: width * 0.18,
                    right: width * 0.02)
                : EdgeInsets.only(
                    bottom: height * 0.01,
                    right: width * 0.18,
                    left: width * 0.02),
            decoration: BoxDecoration(
                // color: widget.map["is_suchi"]
                //     ? Color.fromARGB(255, 32, 145, 79)
                //     : Color.fromARGB(255, 31, 44, 52),
                borderRadius: widget.map["is_suchi"]
                    ? BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))
                    : BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
            child: Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: GestureDetector(
                          onTap: () {
                            if (isplaying) {
                              _controller.pause();
                              setState(() {
                                isplaying = false;
                                tap = tap + 1;
                              });
                            } else {
                              _controller.play();
                              setState(() {
                                isplaying = true;
                                tap = tap + 1;
                              });
                            }
                          },
                          child: Stack(
                            children: [
                              VideoPlayer(_controller),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  margin:
                                      EdgeInsets.only(bottom: height * 0.003),
                                  child: VideoProgressIndicator(
                                    _controller,
                                    allowScrubbing: true,
                                    // colors: VideoProgressColors(
                                    // backgroundColor:
                                    //     Color.fromARGB(255, 11, 20, 27)),
                                  ),
                                ),
                              ),
                              tap == 0
                                  ? Center(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.black45,
                                        radius: 30,
                                        child: Center(
                                          child: Icon(
                                            Icons.play_arrow,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                    )
                                  : _controller.value.isPlaying
                                      ? Container()
                                      : Center(
                                          child: CircleAvatar(
                                            backgroundColor: Colors.black45,
                                            radius: 30,
                                            child: Center(
                                              child: Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                                size: 35,
                                              ),
                                            ),
                                          ),
                                        ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: height * 0),
                                  child: Text(
                                    time,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              )
                            ],
                          )),
                    )
                  : CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }
}

class AudioPlayerScreen extends StatefulWidget {
  final Map map;

  const AudioPlayerScreen({super.key, required this.map});
  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration totalDuration = Duration.zero;
  Duration currentDuration = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Listen to audio duration updates
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        totalDuration = duration;
      });
    });

    // Listen to audio position updates
    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        currentDuration = position;
      });
    });

    // Handle audio playback completion
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        currentDuration = Duration.zero;
      });
    });
  }

  void playPauseAudio() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.map["message_body"]));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var splitTime = widget.map["timestamp"].toString().split(",");
    String date = splitTime[0];
    String time = splitTime[1];
    return Column(
      children: [
        widget.map["changed_date"]
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // width: width * 0.2,
                    // height: height * 0.03,
                    margin: EdgeInsets.only(bottom: height * 0.01),
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03, vertical: height * 0.007),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 11, 20, 27),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        date,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              )
            : Container(),
        Align(
          alignment:
              widget.map["is_suchi"] ? Alignment.topRight : Alignment.topLeft,
          child: Container(
            padding: EdgeInsets.symmetric(
                    vertical: height * 0.004, horizontal: width * 0.01)
                .copyWith(bottom: height * 0.0035),
            margin: widget.map["is_suchi"]
                ? EdgeInsets.only(
                    bottom: height * 0.01,
                    left: width * 0.25,
                    right: width * 0.02)
                : EdgeInsets.only(
                    bottom: height * 0.01,
                    right: width * 0.18,
                    left: width * 0.02),
            decoration: BoxDecoration(
                color: widget.map["is_suchi"]
                    ? Color.fromARGB(255, 32, 145, 79)
                    : Color.fromARGB(255, 31, 44, 52),
                borderRadius: widget.map["is_suchi"]
                    ? BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))
                    : BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    playPauseAudio();
                  },
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.grey[400],
                    size: 38,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Slider(
                        activeColor: Colors.grey[400],
                        inactiveColor: Colors.grey[200],
                        value: currentDuration.inSeconds.toDouble(),
                        max: totalDuration.inSeconds.toDouble(),
                        onChanged: (value) async {
                          final position = Duration(seconds: value.toInt());
                          await _audioPlayer.seek(position);
                          setState(() {
                            currentDuration = position;
                          });
                        },
                      ),
                      // Text(
                      //   "${currentDuration.inMinutes}:${(currentDuration.inSeconds % 60).toString().padLeft(2, '0')} / ${totalDuration.inMinutes}:${(totalDuration.inSeconds % 60).toString().padLeft(2, '0')}",
                      //   style: TextStyle(fontSize: 13),
                      // ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: width * 0.04),
                            child: Text(
                              "${currentDuration.inMinutes}:${(currentDuration.inSeconds % 60).toString().padLeft(2, '0')}",
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: width * 0.02),
                            child: Text(
                              time,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class VoiceAudioScreen extends StatefulWidget {
  final Map map;
  final String audioUrl;

  const VoiceAudioScreen({Key? key, required this.audioUrl, required this.map}) : super(key: key);

  @override
  _VoiceAudioScreenState createState() => _VoiceAudioScreenState();
}

class _VoiceAudioScreenState extends State<VoiceAudioScreen> {
  final audio.AudioPlayer _audioPlayer = audio.AudioPlayer();
  bool isPlaying = false;
  Duration totalDuration = Duration.zero;
  Duration currentDuration = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Load the audio source
    _audioPlayer.setUrl(widget.audioUrl).then((value) {
      setState(() {
        totalDuration = _audioPlayer.duration ?? Duration.zero;
      });
    });

    // Listen to audio position updates
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        currentDuration = position;
      });
    });

  //   // Handle audio playback completion
  //   _audioPlayer.playerStateStream.listen((state) {
  //     if (state.processingState == audio.ProcessingState.completed) {
  //       setState(() {
  //         isPlaying = false;
  //         currentDuration = Duration.zero;
  //       });
  //     }
  //   });
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == audio.ProcessingState.completed) {
        setState(() {
          isPlaying = false;
          currentDuration = Duration.zero;
        });

        // Seek the audio player to the start
        _audioPlayer.seek(Duration.zero);
      }
    });
  }


  void playPauseAudio() {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var splitTime = widget.map["timestamp"].toString().split(",");
    String date = splitTime[0];
    String time = splitTime[1];
    // return Column(
    //   children: [
    //     widget.map["changed_date"]
    //         ? Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         Container(
    //           // width: width * 0.2,
    //           // height: height * 0.03,
    //           margin: EdgeInsets.only(bottom: height * 0.01),
    //           padding: EdgeInsets.symmetric(
    //               horizontal: width * 0.03, vertical: height * 0.007),
    //           decoration: BoxDecoration(
    //               color: Color.fromARGB(255, 11, 20, 27),
    //               borderRadius: BorderRadius.all(Radius.circular(10))),
    //           child: Center(
    //             child: Text(
    //               date,
    //               style: TextStyle(
    //                   color: Colors.white,
    //                   fontSize: 10,
    //                   fontWeight: FontWeight.w600),
    //             ),
    //           ),
    //         )
    //       ],
    //     )
    //         : Container(),
    //     Align(
    //       alignment:
    //       widget.map["is_suchi"] ? Alignment.topRight : Alignment.topLeft,
    //       child: Container(
    //         padding: EdgeInsets.symmetric(
    //             vertical: height * 0.004, horizontal: width * 0.01)
    //             .copyWith(bottom: height * 0.0035),
    //         margin: widget.map["is_suchi"]
    //             ? EdgeInsets.only(
    //             bottom: height * 0.01,
    //             left: width * 0.25,
    //             right: width * 0.02)
    //             : EdgeInsets.only(
    //             bottom: height * 0.01,
    //             right: width * 0.18,
    //             left: width * 0.02),
    //         decoration: BoxDecoration(
    //             color: widget.map["is_suchi"]
    //                 ? Color.fromARGB(255, 32, 145, 79)
    //                 : Color.fromARGB(255, 31, 44, 52),
    //             borderRadius: widget.map["is_suchi"]
    //                 ? BorderRadius.only(
    //                 topLeft: Radius.circular(10),
    //                 bottomLeft: Radius.circular(10),
    //                 bottomRight: Radius.circular(10))
    //                 : BorderRadius.only(
    //                 topRight: Radius.circular(10),
    //                 bottomLeft: Radius.circular(10),
    //                 bottomRight: Radius.circular(10))),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             GestureDetector(
    //               onTap: () {
    //                 playPauseAudio();
    //               },
    //               child: Icon(
    //                 isPlaying ? Icons.pause : Icons.play_arrow,
    //                 color: Colors.grey[400],
    //                 size: 38,
    //               ),
    //             ),
    //             Expanded(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 children: [
    //                   Slider(
    //                     activeColor: Colors.grey[400],
    //                     inactiveColor: Colors.grey[200],
    //                     value: currentDuration.inSeconds.toDouble(),
    //                     max: totalDuration.inSeconds.toDouble(),
    //                     onChanged: (value) async {
    //                       final position = Duration(seconds: value.toInt());
    //                       await _audioPlayer.seek(position);
    //                       setState(() {
    //                         currentDuration = position;
    //                       });
    //                     },
    //                   ),
    //                   // Text(
    //                   //   "${currentDuration.inMinutes}:${(currentDuration.inSeconds % 60).toString().padLeft(2, '0')} / ${totalDuration.inMinutes}:${(totalDuration.inSeconds % 60).toString().padLeft(2, '0')}",
    //                   //   style: TextStyle(fontSize: 13),
    //                   // ),
    //
    //                   Row(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Container(
    //                         padding: EdgeInsets.only(left: width * 0.04),
    //                         child: Text(
    //                           "${currentDuration.inMinutes}:${(currentDuration.inSeconds % 60).toString().padLeft(2, '0')}",
    //                           style: TextStyle(
    //                               color: Colors.grey[400],
    //                               fontSize: 11,
    //                               fontWeight: FontWeight.w500),
    //                         ),
    //                       ),
    //                       Container(
    //                         padding: EdgeInsets.only(right: width * 0.02),
    //                         child: Text(
    //                           time,
    //                           style:
    //                           TextStyle(color: Colors.white, fontSize: 12),
    //                         ),
    //                       ),
    //                     ],
    //                   )
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ],
    // );



    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.map["changed_date"]
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // width: width * 0.2,
                // height: height * 0.03,
                margin: EdgeInsets.only(bottom: height * 0.01),
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03, vertical: height * 0.007),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 11, 20, 27),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text(
                    date,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              )
            ],
          )
              : Container(),
          Align(
                        alignment:
                              widget.map["is_suchi"] ? Alignment.topRight : Alignment.topLeft,
                    child: Container(
                      // width: 100,
                      // height: 100,
                      padding: EdgeInsets.symmetric(
                                    vertical: height * 0.004, horizontal: width * 0.01)
                                    .copyWith(bottom: height * 0.0035),
                                margin: widget.map["is_suchi"]
                                    ? EdgeInsets.only(
                                    bottom: height * 0.01,
                                    left: width * 0.25,
                                    right: width * 0.02)
                                    : EdgeInsets.only(
                                    bottom: height * 0.01,
                                    right: width * 0.18,
                                    left: width * 0.02),
                                decoration: BoxDecoration(
                                    color: widget.map["is_suchi"]
                                        ? Color.fromARGB(255, 32, 145, 79)
                                        : Color.fromARGB(255, 31, 44, 52),
                                    borderRadius: widget.map["is_suchi"]
                                        ? BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))
                                        : BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  playPauseAudio();
                                },
                                child: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                  size: 50,
                                  color: Colors.grey[400],
                                ),
                              ),

                              Expanded(
                                child: Slider(
                                  value: currentDuration.inSeconds.toDouble(),
                                  max: totalDuration.inSeconds.toDouble(),
                                  activeColor: Colors.grey[400],
                                  onChanged: (value) async {
                                    final position = Duration(seconds: value.toInt());
                                    await _audioPlayer.seek(position);
                                    setState(() {
                                      currentDuration = position;
                                    });
                                  },
                                ),
                              ),

                            ],
                          ),

                          Text(
                            time,
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  )

          ,

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         "${currentDuration.inMinutes}:${(currentDuration.inSeconds % 60).toString().padLeft(2, '0')}",
          //         style: TextStyle(fontSize: 16,color: Colors.white),
          //       ),
          //       Text(
          //         "${totalDuration.inMinutes}:${(totalDuration.inSeconds % 60).toString().padLeft(2, '0')}",
          //         style: TextStyle(fontSize: 16,color: Colors.white),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
