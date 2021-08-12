import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:universal_ui/universal_ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

List<String> videoUrls = [
  'https://ks3-cn-beijing.ksyun.com/videotest/movie/%E5%A4%A9%E6%B0%94%E4%B9%8B%E5%AD%90/%E5%A4%A9%E6%B0%94%E4%B9%8B%E5%AD%90.m3u8',
  'https://ks3-cn-beijing.ksyun.com/videotest/short_video/202108091457/m3u8/1.m3u8',
  'https://vod4.buycar5.cn/20210512/mYvB1MkB/index.m3u8',
  'https://1251316161.vod2.myqcloud.com/007a649dvodcq1251316161/45d870155285890812491498931/24c2SGTVjrcA.mp4',
  'https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8',
  'https://v2.88zy.site/20210717/w0WsRtgh/index.m3u8',
];

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  String _currentVideoUrl = videoUrls[0];

  void _incrementCounter() {
    setState(() => _counter++);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(height: 10.0),
              HtmlVideoWidget(
                url: _currentVideoUrl,
                width: 400.0,
                height: 226.0,
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: () => setState(() => _currentVideoUrl = videoUrls[0]), child: Text('video 1')),
                  ElevatedButton(onPressed: () => setState(() => _currentVideoUrl = videoUrls[1]), child: Text('video 2')),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: () => setState(() => _currentVideoUrl = videoUrls[2]), child: Text('video 3')),
                  ElevatedButton(onPressed: () => setState(() => _currentVideoUrl = videoUrls[3]), child: Text('video 4')),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      );
}

class HtmlVideoWidget extends StatefulWidget {
  final String url;
  final double width;
  final double height;

  const HtmlVideoWidget({
    Key? key,
    required this.url,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  _HtmlVideoWidgetState createState() => _HtmlVideoWidgetState();
}

class _HtmlVideoWidgetState extends State<HtmlVideoWidget> {
  String createdViewId = 'map_element';
  Key _upKey = GlobalKey();

  @override
  void initState() {
    _registerFrameElement();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        key: _upKey,
        width: widget.width,
        height: widget.height,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: HtmlElementView(viewType: createdViewId),
        ),
      );

  void _registerFrameElement() {
    ui.platformViewRegistry.registerViewFactory(
      createdViewId,
      (int viewId) => html.IFrameElement()
        ..width = widget.width.toString()
        ..height = widget.height.toString()
        ..srcdoc = htmlContent
        ..style.border = 'none',
    );
  }

  @override
  void didUpdateWidget(HtmlVideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.url != widget.url) {
      _registerFrameElement();
      _upKey = GlobalKey();
    }
  }

  String get htmlContent => '''
  <!DOCTYPE html>
    <html>
    <head>
    <meta charset=utf-8 />
    <title>Your title</title>
      <link href="https://unpkg.com/video.js/dist/video-js.css" rel="stylesheet">
      <script src="https://unpkg.com/video.js/dist/video.js"></script>
      <script src="https://unpkg.com/videojs-contrib-hls/dist/videojs-contrib-hls.js"></script>
    </head>
    <body>
      <video id="my_video_1" class="video-js vjs-fluid vjs-default-skin" controls preload="auto"
      data-setup='{}'>
        <source src="${widget.url}" type="application/x-mpegURL">
      </video>
    <script>
    var player = videojs('my_video_1');
    player.play();
    </script>
      
    </body>
    </html>
  ''';
}
