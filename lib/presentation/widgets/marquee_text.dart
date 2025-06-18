import 'package:flutter/material.dart';

class MarqueeWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double gap;

  const MarqueeWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 8),
    this.gap = 24.0,
  });

  @override
  State<MarqueeWidget> createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  late final ScrollController _scrollController;
  bool _needsMarquee = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) => _startMarqueeIfNeeded());
  }
  
  void _startMarqueeIfNeeded() {
    
    if (!mounted || !_scrollController.hasClients) return;

    
    if (_scrollController.position.maxScrollExtent > 0) {
      setState(() {
        _needsMarquee = true;
      });
      
      _scroll();
    }
  }

 
  void _scroll() async {
    while (_needsMarquee && mounted) {
      
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      
      
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: widget.duration,
        curve: Curves.linear,
      );
      if (!mounted) return;
      
      
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      
      
      _scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The SingleChildScrollView is the core of this widget.
    // It's a single, scrollable line of content.
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(), // User can't scroll manually.
      // The child is a Row containing two copies of the content.
      // This is the trick to making the loop seamless.
      child: Row(
        children: [
          widget.child,
          // We only add the second copy if scrolling is actually needed.
          if (_needsMarquee)
            Padding(
              padding: EdgeInsets.only(left: widget.gap),
              child: widget.child,
            ),
        ],
      ),
    );
  }
}