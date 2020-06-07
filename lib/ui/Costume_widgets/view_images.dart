import 'package:flutter/material.dart';
import 'package:house_of_joy/ui/Costume_widgets/post_widget.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

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
      _pages = widget.imagesUrl.map((url) {
        return _buildNetworkImagePageItem(url);
      }).toList();
    } else {
      _pages = widget.assetImages.map((assetImage) {
        return _buildAssetsImagePageItem(assetImage);
      }).toList();
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
                              color: Color(0xffFD85CB),
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: Icon(Icons.arrow_back_ios, size: 15),
                          ),
                          onPressed: () {
                            _controller.previousPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          }),
                      IconButton(
                        color: Colors.white,
                        icon: Container(
                          width: 35,
                          height: 33,
                          decoration: BoxDecoration(
                            color: Color(0xffFD85CB),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Icon(Icons.arrow_forward_ios, size: 15),
                        ),
                        onPressed: () {
                          _controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease,
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
        physics: AlwaysScrollableScrollPhysics(),
        controller: _controller,
        itemCount: _pages.length,
        itemBuilder: (BuildContext context, int index) {
          return _pages[_cirrentPageIndex];
        },
        onPageChanged: (int p) {
          setState(() {
            _cirrentPageIndex = p;
          });
        },
      ),
    );
  }

  Widget _buildNetworkImagePageItem(String imgUrl) {
    return Container(
      decoration: BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: LoadImage(url: imgUrl),
      ),
    );
  }

  Widget _buildAssetsImagePageItem(Asset assetImage) {
    return Container(
      decoration: BoxDecoration(),
      child: AssetThumb(
        asset: assetImage,
        width: 400,
        height: 200,
      ),
    );
  }
}
