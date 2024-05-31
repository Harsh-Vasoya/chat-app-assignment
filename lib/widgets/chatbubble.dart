import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_assignment/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';


class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.isMe,
    required this.message,
  });

  final bool isMe;
  final DocumentSnapshot message;

  @override
  Widget build(BuildContext context) {
    final data = message.data() as Map<String, dynamic>?;
    String mediaType = data!['mediaType'] ?? 'text';
    String messagetext = data['text'];
    String? photoUrl = data['photoUrl'];
    String? videoUrl = data['videoUrl'];
    String? thumbnailUrl = data['thumbnailUrl'];
    String? documentUrl = data['documentUrl'];


    return Align(
      alignment: isMe ? Alignment.topLeft : Alignment.topRight,
      child: Container(
        decoration: BoxDecoration(
          color: greenColor,
          borderRadius: isMe
              ? const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          )
              : const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            if (mediaType == '') ...[
              Text(messagetext, style: appbarFont),
            ]
            else if (mediaType == 'image' && photoUrl != null) ...[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhotoView(
                        imageProvider: CachedNetworkImageProvider(photoUrl),
                        minScale: PhotoViewComputedScale.contained * 0.8,
                        maxScale: PhotoViewComputedScale.covered * 2,
                        initialScale: PhotoViewComputedScale.contained,
                      ),
                    ),
                  );
                },
                child: CachedNetworkImage(
                  imageUrl: photoUrl,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: primaryColor,)),
                  errorWidget: (context, url, error) => const Icon(Icons.error, color: primaryColor,),
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ] else if (mediaType == 'video' && thumbnailUrl != null) ...[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(videoUrl: videoUrl!),
                  ));
                },
                child: CachedNetworkImage(
                  imageUrl: thumbnailUrl,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: primaryColor,)),
                  errorWidget: (context, url, error) => const Icon(Icons.error, color: primaryColor,),
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ] else if (mediaType == 'document' && documentUrl != null) ...[
              Row(
                children: [
                  const Icon(Icons.description, size: 24, color: primaryColor,),
                  TextButton(
                    onPressed: () async {
                      if (await canLaunchUrl(Uri.parse(documentUrl))) {
                        await launchUrl(Uri.parse(documentUrl));
                      } else {
                        throw 'Could not launch $documentUrl';
                      }
                    },
                    child: Text('Click to open document', style: appbarFont,),
                  ),
                ],
              )
            ],
            const SizedBox(height: 3,),
            Text(
              DateFormat.Hm().format(
                data['sentTime'].toDate(),
              ),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player', style: appbarFont,),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: greenColor,
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}