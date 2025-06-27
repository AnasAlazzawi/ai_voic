import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

// تطبيق Friday Jarvis الصوتي - محسن للأداء والاستقرار مع إعادة الاتصال
class FridayJarvisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friday Jarvis AI Assistant',
      theme: ThemeData(primarySwatch: Colors.deepPurple, fontFamily: 'Arabic'),
      home: VoiceAssistantPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class VoiceAssistantPage extends StatefulWidget {
  @override
  _VoiceAssistantPageState createState() => _VoiceAssistantPageState();
}

class _VoiceAssistantPageState extends State<VoiceAssistantPage> {
  Room? _room;
  bool _isConnected = false;
  bool _isMuted = false;
  String _connectionStatus = 'غير متصل';

  // معلومات الاتصال المحدثة من Railway (Token جديد)
  final String _url = 'wss://aivoic-tqnojuug.livekit.cloud';
  final String _token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJBUElQUHFhQnRkajlTREEiLCJleHAiOjE3ODI1NTU0MDAsIm5iZiI6MTc1MTAxOTM5MCwic3ViIjoicmFpbHdheS11c2VyIiwidmlkZW8iOnsicm9vbSI6ImZyaWRheS1qYXJ2aXMtcm9vbSIsInJvb21Kb2luIjp0cnVlLCJjYW5QdWJsaXNoIjp0cnVlLCJjYW5TdWJzY3JpYmUiOnRydWV9fQ.zZTnYrhtJwWCexr3VWP1MsGfuaDwFBKs5E7HtqaH3X8';

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _initializeLiveKit();
  }

  Future<void> _initializeLiveKit() async {
    try {
      await Hardware.instance.enableAudio();
      await Hardware.instance.setSpeakerphoneOn(true);
      print('✅ تم تهيئة إعدادات LiveKit بنجاح');
    } catch (e) {
      print('❌ خطأ في تهيئة LiveKit: $e');
    }
  }

  Future<void> _requestPermissions() async {
    try {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.microphone].request();

      print('صلاحيات الميكروفون: ${statuses[Permission.microphone]}');

      if (statuses[Permission.microphone] != PermissionStatus.granted) {
        _showErrorDialog('يرجى السماح بالوصول للميكروفون لاستخدام التطبيق');
      }
    } catch (e) {
      print('خطأ في طلب الصلاحيات: $e');
    }
  }

  Future<void> _connectToRoom() async {
    try {
      setState(() {
        _connectionStatus = 'جاري الاتصال...';
      });

      // إغلاق الاتصال السابق إن وجد
      if (_room != null) {
        try {
          await _room!.disconnect();
        } catch (e) {
          print('تحذير: خطأ في إغلاق الاتصال السابق: $e');
        }
        _room = null;
      }

      _room = Room();
      _room!.addListener(_onRoomUpdate);
      _room!.addListener(() {
        _handleRoomStateChange();
      });

      final connectOptions = ConnectOptions(
        autoSubscribe: true,
        publishOnlyMode: false,
      );

      await _room!.connect(_url, _token, connectOptions: connectOptions);
      await _room!.localParticipant?.setMicrophoneEnabled(true);

      try {
        await Hardware.instance.setSpeakerphoneOn(true);
      } catch (e) {
        print('تحذير: لا يمكن تفعيل مكبر الصوت: $e');
      }

      setState(() {
        _isConnected = true;
        _connectionStatus = 'متصل مع Friday Jarvis';
      });

      print('🎉 متصل بنجاح مع Friday Jarvis!');
      _handleRoomStateChange();
    } catch (e) {
      setState(() {
        _connectionStatus = 'خطأ في الاتصال';
        _isConnected = false;
      });
      print('❌ خطأ في الاتصال: $e');
      _showErrorDialog('خطأ في الاتصال: $e');
    }
  }

  void _onRoomUpdate() {
    if (mounted) {
      setState(() {});
      _handleRoomStateChange();
    }
  }

  void _handleRoomStateChange() {
    if (_room == null) return;

    for (var participant in _room!.remoteParticipants.values) {
      print('🎯 معالجة مشارك: ${participant.identity}');
      participant.addListener(() {
        _handleParticipantTracks(participant);
      });
      _handleParticipantTracks(participant);
    }

    setState(() {});
  }

  void _handleParticipantTracks(participant) {
    for (var publication in participant.audioTrackPublications) {
      if (publication.track != null) {
        print('🔊 مقطع صوتي من ${participant.identity}: ${publication.track.runtimeType}');

        if (!publication.subscribed) {
          print('🔄 محاولة الاشتراك في المقطع الصوتي...');
          try {
            publication.track?.enable();
          } catch (e) {
            print('❌ خطأ في تفعيل المقطع: $e');
          }
        } else {
          print('✅ المقطع الصوتي نشط ومُشترك');
          try {
            publication.track?.enable();
            print('🎵 تم تفعيل تشغيل الصوت');
          } catch (e) {
            print('❌ خطأ في تشغيل الصوت: $e');
          }
        }
      }
    }
  }

  Future<void> _disconnect() async {
    try {
      await _room?.disconnect();
      setState(() {
        _isConnected = false;
        _connectionStatus = 'غير متصل';
      });
      print('⏹️ تم قطع الاتصال');
    } catch (e) {
      print('❌ خطأ في قطع الاتصال: $e');
    }
  }

  Future<void> _toggleMute() async {
    if (_room != null) {
      try {
        bool newMuteState = !_isMuted;
        await _room!.localParticipant?.setMicrophoneEnabled(!newMuteState);
        setState(() {
          _isMuted = newMuteState;
        });
        print('🎤 تم ${newMuteState ? "كتم" : "إلغاء كتم"} الميكروفون');
      } catch (e) {
        print('❌ خطأ في تغيير حالة الكتم: $e');
      }
    }
  }

  // دالة إعادة الاتصال المحسنة
  Future<void> _reconnect() async {
    print('🔄 محاولة إعادة الاتصال...');
    await _disconnect();
    await Future.delayed(Duration(seconds: 2)); // انتظار قصير
    await _connectToRoom();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('خطأ'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('موافق'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Friday Jarvis Assistant',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade700],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // شريط المعلومات العلوي
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: Card(
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          _connectionStatus,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _isConnected ? Colors.green : Colors.red,
                          ),
                        ),
                        if (_isConnected) ...[
                          SizedBox(height: 8),
                          Text(
                            'عدد المشاركين: ${_room?.remoteParticipants.length ?? 0}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // المنطقة الرئيسية
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // أيقونة الحالة الرئيسية
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isConnected ? Colors.green : Colors.grey,
                          boxShadow: [
                            BoxShadow(
                              color: (_isConnected ? Colors.green : Colors.grey)
                                  .withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isConnected
                              ? (_isMuted ? Icons.mic_off : Icons.mic)
                              : Icons.mic_none,
                          size: 90,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 40),

                      // أزرار التحكم مع زر إعادة الاتصال
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          // زر الاتصال/قطع الاتصال
                          ElevatedButton.icon(
                            onPressed:
                                _isConnected ? _disconnect : _connectToRoom,
                            icon: Icon(
                              _isConnected ? Icons.call_end : Icons.call,
                            ),
                            label: Text(
                              _isConnected ? 'قطع الاتصال' : 'اتصال',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _isConnected ? Colors.red : Colors.green,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),

                          // زر كتم الصوت
                          if (_isConnected)
                            ElevatedButton.icon(
                              onPressed: _toggleMute,
                              icon: Icon(_isMuted ? Icons.mic_off : Icons.mic),
                              label: Text(
                                _isMuted ? 'إلغاء الكتم' : 'كتم',
                                style: TextStyle(fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _isMuted ? Colors.orange : Colors.blue,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),

                          // زر إعادة الاتصال - يظهر عند الخطأ
                          if (!_isConnected && _connectionStatus.contains('خطأ'))
                            ElevatedButton.icon(
                              onPressed: _reconnect,
                              icon: Icon(Icons.refresh),
                              label: Text(
                                'إعادة الاتصال',
                                style: TextStyle(fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: 40),

                      // رسالة الإرشاد
                      if (_isConnected)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.info, color: Colors.white, size: 30),
                              SizedBox(height: 10),
                              Text(
                                'مرحباً! يمكنك الآن التحدث مع Friday Jarvis',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'جرب أن تقول:\n• "ما هو الطقس اليوم؟"\n• "ابحث عن معلومات عن الذكاء الاصطناعي"\n• "أخبرني نكتة"',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
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
    _room?.removeListener(_onRoomUpdate);
    _room?.disconnect();
    super.dispose();
  }
}

// نقطة البداية للتطبيق
void main() {
  runApp(FridayJarvisApp());
}
