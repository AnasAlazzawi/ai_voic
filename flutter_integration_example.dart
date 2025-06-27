import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceAssistantPage extends StatefulWidget {
  @override
  _VoiceAssistantPageState createState() => _VoiceAssistantPageState();
}

class _VoiceAssistantPageState extends State<VoiceAssistantPage> {
  Room? _room;
  bool _isConnected = false;
  bool _isMuted = false;

  // معلومات الاتصال - Token جديد طويل المدى
  final String _url = 'wss://aivoic-tqnojuug.livekit.cloud';
  final String _token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJBUElQUHFhQnRkajlTREEiLCJleHAiOjE3ODI1NTUxMjgsIm5iZiI6MTc1MTAxOTExOCwic3ViIjoicmFpbHdheS11c2VyIiwidmlkZW8iOnsicm9vbSI6ImZyaWRheS1qYXJ2aXMtcm9vbSIsInJvb21Kb2luIjp0cnVlLCJjYW5QdWJsaXNoIjp0cnVlLCJjYW5TdWJzY3JpYmUiOnRydWV9fQ.qz-9NK64Vh3ekFS1P5F_eBXnAnew7-5EpsdJbpwg-pI';

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [Permission.microphone].request();
  }

  Future<void> _connectToRoom() async {
    try {
      _room = Room();

      // إعداد المستمعين للأحداث
      _room!.addListener(_onRoomEvent);

      // الاتصال بالغرفة
      await _room!.connect(_url, _token);

      // تفعيل الميكروفون
      await _room!.localParticipant?.setMicrophoneEnabled(true);

      setState(() {
        _isConnected = true;
      });

      print('متصل بنجاح مع الوكيل الصوتي!');
    } catch (e) {
      print('خطأ في الاتصال: $e');
    }
  }

  void _onRoomEvent() {
    // التعامل مع أحداث الغرفة
    if (_room != null) {
      // التعامل مع المشاركين البعيدين
      for (var participant in _room!.remoteParticipants.values) {
        for (var publication in participant.audioTrackPublications) {
          if (publication.track != null) {
            // تشغيل الصوت من الوكيل
            print('تم استلام صوت من المشارك: ${participant.identity}');
          }
        }
      }
    }
  }

  Future<void> _disconnect() async {
    await _room?.disconnect();
    setState(() {
      _isConnected = false;
    });
  }

  Future<void> _toggleMute() async {
    if (_room != null) {
      bool newMuteState = !_isMuted;
      await _room!.localParticipant?.setMicrophoneEnabled(!newMuteState);
      setState(() {
        _isMuted = newMuteState;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friday Jarvis Assistant'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade700],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أيقونة الوكيل
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isConnected ? Colors.green : Colors.grey,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  _isConnected ? Icons.mic : Icons.mic_off,
                  size: 80,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 30),

              // حالة الاتصال
              Text(
                _isConnected ? 'متصل مع Friday Jarvis' : 'غير متصل',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 50),

              // أزرار التحكم
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // زر الاتصال/قطع الاتصال
                  ElevatedButton.icon(
                    onPressed: _isConnected ? _disconnect : _connectToRoom,
                    icon: Icon(_isConnected ? Icons.call_end : Icons.call),
                    label: Text(_isConnected ? 'قطع الاتصال' : 'اتصال'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isConnected ? Colors.red : Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),

                  // زر كتم الصوت
                  if (_isConnected)
                    ElevatedButton.icon(
                      onPressed: _toggleMute,
                      icon: Icon(_isMuted ? Icons.mic_off : Icons.mic),
                      label: Text(_isMuted ? 'إلغاء الكتم' : 'كتم'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isMuted ? Colors.orange : Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: 30),

              // معلومات إضافية
              if (_isConnected)
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'يمكنك الآن التحدث مع Friday Jarvis\n'
                    'اسأل عن الطقس أو ابحث في الويب',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _room?.removeListener(_onRoomEvent);
    _room?.disconnect();
    super.dispose();
  }
}

// استخدام الصفحة في التطبيق الرئيسي
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friday Jarvis Assistant',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: VoiceAssistantPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(MyApp());
}
