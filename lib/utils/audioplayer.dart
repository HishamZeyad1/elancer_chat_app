// import 'package:audioplayers/audioplayers.dart';
//
// class AudPlayer{
//   static final AudPlayer _instance = AudPlayer._();
//   AudPlayer._();
//   factory AudPlayer() {
//     return _instance;
//   }
//
//   AudioPlayer audioPlayer = AudioPlayer();
//   bool isPlaying = false;
//
//   Future<void> playRingtone() async {
//     isPlaying = true;
//     final player = AudioPlayer();
//     while (isPlaying) {
//     await audioPlayer.play(AssetSource('receiver.mp3'),);
//     // Stop the audio after the specified duration
//     }
//     // audioPlayer.onPlayerComplete.listen((event) {
//     //   // Loop the ringtone when it completes
//     //   audioPlayer.seek(Duration.zero);
//     //   audioPlayer.resume();
//     // });
//     // await player.play(UrlSource('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3'));
//
//   }
//
//   void stopRingtone() {
//     isPlaying = false;
//     audioPlayer.stop();
//   }
//   void resumeAudio() {
//     audioPlayer.resume();
//   }
//   void pauseAudio() {
//     audioPlayer.pause();
//   }
//   void disposeAudioPlayer() {
//     audioPlayer.release();
//   }
//
// }
