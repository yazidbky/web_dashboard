import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

class GrafanaIframe extends StatefulWidget {
  final String url;

  const GrafanaIframe({
    super.key,
    required this.url,
  });

  @override
  State<GrafanaIframe> createState() => _GrafanaIframeState();
}

class _GrafanaIframeState extends State<GrafanaIframe> {
  late String _iframeId;
  html.IFrameElement? _iframeElement;

  @override
  void initState() {
    super.initState();
    _iframeId = 'grafana-iframe-${DateTime.now().millisecondsSinceEpoch}-${widget.url.hashCode}';
    _createIframe();
  }

  @override
  void didUpdateWidget(GrafanaIframe oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If URL changed, update the iframe source
    if (oldWidget.url != widget.url) {
      if (_iframeElement != null) {
        _iframeElement!.src = widget.url;
      } else {
        // If element is null, recreate
        _createIframe();
      }
    }
  }

  void _createIframe() {
    // Use the URL as-is (it should already have viewPanel parameter)
    final displayUrl = widget.url;
    
    // Create the iframe element
    _iframeElement = html.IFrameElement()
      ..src = displayUrl
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..allowFullscreen = true
      ..allow = 'fullscreen';
    
    // Register the iframe element with a unique ID
    try {
      ui_web.platformViewRegistry.registerViewFactory(
        _iframeId,
        (int viewId) => _iframeElement!,
      );
    } catch (e) {
      print('⚠️ [GrafanaIframe] Error registering view factory: $e');
      // If registration fails (e.g., ID already exists), generate a new one
      _iframeId = 'grafana-iframe-${DateTime.now().millisecondsSinceEpoch}-${widget.url.hashCode}';
      ui_web.platformViewRegistry.registerViewFactory(
        _iframeId,
        (int viewId) => _iframeElement!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      viewType: _iframeId,
    );
  }
}

