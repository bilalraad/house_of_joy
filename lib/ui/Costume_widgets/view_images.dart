import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class ViewImages extends StatefulWidget {
  final List<String> imagesUrl;
  final List<Asset> assetImages;

  const ViewImages({this.imagesUrl, this.assetImages});

  @override
  _ViewImagesState createState() => _ViewImagesState();
}

class _ViewImagesState extends State<ViewImages>
    with SingleTickerProviderStateMixin {
  final _controller = PageController();
  List<Widget> _pages = [];
  int _cirrentPageIndex = 0;

  @override
  void initState() {
    if (widget.imagesUrl != null) {
      _pages = widget.imagesUrl.map(_buildNetworkImagePageItem).toList();
    } else {
      _pages = widget.assetImages.map(_buildAssetsImagePageItem).toList();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        children: <Widget>[
          _buildPagerViewSlider(),
          _pages.length == 1
              ? Container()
              : Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                          color: Colors.white,
                          icon: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: const Color(0xffFD85CB),
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: const Icon(Icons.arrow_back_ios, size: 15),
                          ),
                          onPressed: () {
                            _controller.previousPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                            );
                          }),
                      IconButton(
                        color: Colors.white,
                        icon: Container(
                          width: 35,
                          height: 33,
                          decoration: BoxDecoration(
                            color: const Color(0xffFD85CB),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: const Icon(Icons.arrow_forward_ios, size: 15),
                        ),
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                          );
                        },
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildPagerViewSlider() {
    return Positioned.fill(
      child: PageView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _controller,
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return _pages[_cirrentPageIndex];
        },
        onPageChanged: (p) {
          setState(() {
            _cirrentPageIndex = p;
          });
        },
      ),
    );
  }

  Widget _buildNetworkImagePageItem(String imgUrl) {
    return Container(
      decoration: const BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: LoadImage(url: imgUrl),
      ),
    );
  }

  Widget _buildAssetsImagePageItem(Asset assetImage) {
    return Container(
      decoration: const BoxDecoration(),
      child: AssetThumb(
        asset: assetImage,
        width: 400,
        height: 200,
        spinner: const SizedBox(
            width: 30, height: 30, child: CircularProgressIndicator()),
      ),
    );
  }
}

class LoadImage extends StatefulWidget {
  const LoadImage(
      {@required this.url,
      this.fit = BoxFit.contain,
      this.boxShape = BoxShape.rectangle});

  final String url;
  final BoxFit fit;
  final BoxShape boxShape;

  @override
  _LoadImageState createState() => _LoadImageState();
}

class _LoadImageState extends State<LoadImage> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      widget.url,
      fit: widget.fit,
      shape: widget.boxShape,
      width: MediaQuery.of(context).size.width * 0.75,
      cache: true,
      mode: ExtendedImageMode.gesture,
      initGestureConfigHandler: (state) {
        return GestureConfig(
          minScale: 0.9,
          animationMinScale: 0.7,
          maxScale: 3.0,
          animationMaxScale: 3.5,
          speed: 1.0,
          inertialSpeed: 100.0,
          initialScale: 1.0,
          inPageView: false,
          initialAlignment: InitialAlignment.center,
        );
      },
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {

          ///if you don't want override completed widget
          ///please return null or state.completedWidget
          //return null;
          //return state.completedWidget;
          case LoadState.completed:
            _controller.forward();
            return FadeTransition(
              opacity: _controller,
              child: ExtendedRawImage(
                fit: widget.fit,
                image: state.extendedImageInfo?.image,
              ),
            );
            break;
          case LoadState.failed:
            _controller.reset();
            return GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('خطا غير معروف'),
                  const Text(
                    "اضغط لأعادة تحميل الصورة",
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              onTap: () {
                state.reLoadImage();
              },
            );
            break;

          default:
            return null;
        }
      },
    );
  }
}
