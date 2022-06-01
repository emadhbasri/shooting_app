import 'dart:async';

import 'package:shooting_app/classes/functions.dart';

import '../../any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'link_analyzer.dart';
import '../widgets/link_view_horizontal.dart';
import '../widgets/link_view_vertical.dart';

enum UIDirection { uiDirectionVertical, uiDirectionHorizontal }

class AnyLinkPreview extends StatefulWidget {
  final Function doIt;

  /// Display direction. One among `uiDirectionVertical, uiDirectionHorizontal`
  /// By default it is `uiDirectionVertical`
  final UIDirection displayDirection;

  /// Parameter to choose how you'd like the app to handle the link
  /// Default is `LaunchMode.platformDefault`
  final LaunchMode urlLaunchMode;

  /// Web address (Url that need to be parsed)
  /// For IOS & Web, only HTTP and HTTPS are support
  /// For Android, all url's are supported
  final String link;

  /// Customize background colour
  /// Deaults to `Color.fromRGBO(235, 235, 235, 1)`
  final Color? backgroundColor;

  /// Widget that need to be shown when
  /// plugin is trying to fetch metadata
  /// If not given anything then default one will be shown
  final Widget? placeholderWidget;

  /// Widget that need to be shown if something goes wrong
  /// Defaults to plain container with given background colour
  /// If the issue is know then we will show customized UI
  /// Other options of error params are used
  final Widget? errorWidget;

  /// Title that need to be shown if something goes wrong
  /// Deaults to `Something went wrong!`
  final String? errorTitle;

  /// Body that need to be shown if something goes wrong
  /// Deaults to `Oops! Unable to parse the url. We have sent feedback to our developers & we will try to fix this in our next release. Thanks!`
  final String? errorBody;

  /// Image that will be shown if something goes wrong
  /// & when multimedia enabled & no meta data is available
  /// Deaults to `A semi-soccer ball image that looks like crying`
  final String? errorImage;

  /// Give the overflow type for body text (Description)
  /// Deaults to `TextOverflow.ellipsis`
  final TextOverflow bodyTextOverflow;

  /// Give the limit to body text (Description)
  /// Deaults to `3`
  final int bodyMaxLines;

  /// Cache result time, default cache `1 day`
  /// Pass null to disable
  final Duration cache;

  /// Customize body `TextStyle`
  final TextStyle? titleStyle;

  /// Customize body `TextStyle`
  final TextStyle? bodyStyle;

  /// Show or Hide image if available defaults to `true`
  final bool showMultimedia;

  /// BorderRadius for the card. Deafults to `12`
  final double? borderRadius;

  /// To remove the card elevation set it to `true`
  /// Default value is `false`
  final bool removeElevation;

  /// Box shadow for the card. Deafults to `[BoxShadow(blurRadius: 3, color: Colors.grey)]`
  final List<BoxShadow>? boxShadow;

  /// Proxy URL to pass that resolve CORS issues on web.
  /// For example, `https://cors-anywhere.herokuapp.com/` .
  final String? proxyUrl;

  /// Headers to be added in the HTTP request to the link
  final Map<String, String>? headers;

  /// Function that needs to be called when user taps on the card.
  /// If not given then given URL will be launched.
  /// To disable, Pass empty function.
  final void Function()? onTap;

  const AnyLinkPreview({
    Key? key,
    required this.link,
    this.cache = const Duration(days: 1),
    this.titleStyle,
    this.bodyStyle,
    required this.doIt,
    this.displayDirection = UIDirection.uiDirectionVertical,
    this.showMultimedia = true,
    this.backgroundColor = const Color.fromRGBO(235, 235, 235, 1),
    this.bodyMaxLines = 3,
    this.bodyTextOverflow = TextOverflow.ellipsis,
    this.placeholderWidget,
    this.errorWidget,
    this.errorBody,
    this.errorImage,
    this.errorTitle,
    this.borderRadius,
    this.boxShadow,
    this.removeElevation = false,
    this.proxyUrl,
    this.headers,
    this.onTap,
    this.urlLaunchMode = LaunchMode.platformDefault,
  }) : super(key: key);

  @override
  AnyLinkPreviewState createState() => AnyLinkPreviewState();

  /// Method to fetch metadata directly
  static Future<Metadata?> getMetadata({
    required String link,
    String? proxyUrl = '', // Pass for web
    Duration? cache = const Duration(days: 1),
    Map<String, String>? headers,
  }) async {
    var linkValid = isValidLink(link);
    var proxyValid = true;
    if ((proxyUrl ?? '').isNotEmpty) proxyValid = isValidLink(proxyUrl!);
    if (linkValid && proxyValid) {
      var linkToFetch = ((proxyUrl ?? '') + link).trim();
      try {
        var info = await LinkAnalyzer.getInfo(linkToFetch,
            cache: cache, headers: headers);
        return info;
      } catch (error) {
        return null;
      }
    } else if (!linkValid) {
      throw Exception('Invalid link');
    } else {
      throw Exception('Proxy URL is invalid. Kindly pass only if required');
    }
  }

  /// Method to verify if the link is valid or not
  static bool isValidLink(
    String link, {
    List<String> protocols = const ['http', 'https', 'ftp'],
    List<String> hostWhitelist = const [],
    List<String> hostBlacklist = const [],
    bool requireTld = true,
    bool requireProtocol = false,
    bool allowUnderscore = false,
  }) {
    if (link.isEmpty) return false;
    Map<String, Object>? options = {
      'require_tld': requireTld,
      'require_protocol': requireProtocol,
      'allow_underscores': allowUnderscore,
      // 'require_port': false,
      // 'require_valid_protocol': true,
      // 'allow_trailing_dot': false,
      // 'allow_protocol_relative_urls': false,
      // 'allow_fragments': true,
      // 'allow_query_components': true,
      // 'disallow_auth': false,
      // 'validate_length': true
    };
    if (protocols.isNotEmpty) options['protocols'] = protocols;
    if (hostWhitelist.isNotEmpty) options['host_whitelist'] = hostWhitelist;
    if (hostBlacklist.isNotEmpty) options['host_blacklist'] = hostBlacklist;
    var isValid = isURL(link, options);
    return isValid;
  }
}

class AnyLinkPreviewState extends State<AnyLinkPreview> {
  BaseMetaInfo? _info;
  String? _errorImage, _errorTitle, _errorBody;
  bool _loading = false;
  bool _linkValid = false, _proxyValid = true;

  @override
  void initState() {
    _errorImage = widget.errorImage ??
        'https://github.com/sur950/any_link_preview/blob/master/lib/assets/giphy.gif?raw=true';
    _errorTitle = widget.errorTitle ?? 'Something went wrong!';
    _errorBody = widget.errorBody ??
        'Oops! Unable to parse the url. We have sent feedback to our developers & we will try to fix this in our next release. Thanks!';

    _linkValid = AnyLinkPreview.isValidLink(widget.link);
    if ((widget.proxyUrl ?? '').isNotEmpty) {
      _proxyValid = AnyLinkPreview.isValidLink(widget.proxyUrl!);
    }
    if (_linkValid && _proxyValid) {
      var linkToFetch = ((widget.proxyUrl ?? '') + widget.link).trim();
      _loading = true;
      _getInfo(linkToFetch);
    }
    super.initState();
  }

  Future<void> _getInfo(String link) async {
    try {
      _info = await LinkAnalyzer.getInfo(link,
          cache: widget.cache, headers: widget.headers);
    } catch (error) {
      _info = null;
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  void _launchURL(url) async {
    var uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: widget.urlLaunchMode);
    } else {
      try {
        await launchUrl(uri, mode: widget.urlLaunchMode);
      } catch (err) {
        throw Exception('Could not launch $url. Error: $err');
      }
    }
  }

  Widget _buildPlaceHolder(Color color, double defaultHeight) {
    return SizedBox(
      height: defaultHeight,
      child: LayoutBuilder(builder: (context, constraints) {
        var layoutWidth = constraints.biggest.width;
        var layoutHeight = constraints.biggest.height;

        return Container(
          color: color,
          width: layoutWidth,
          height: layoutHeight,
        );
      }),
    );
  }

  Widget _buildLinkContainer(
    double height, {
    String? title = '',
    String? desc = '',
    String? image = '',
  }) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
        boxShadow: widget.removeElevation
            ? []
            : widget.boxShadow ??
                [const BoxShadow(blurRadius: 3, color: Colors.grey)],
      ),
      height: height,
      child: (widget.displayDirection == UIDirection.uiDirectionHorizontal)
          ? LinkViewHorizontal(
              key: widget.key ?? Key(widget.link.toString()),
              url: widget.link,
              title: title!,
              description: desc!,
              imageUri: image!,
              onTap: widget.onTap ?? () => _launchURL(widget.link),
              onLongPress: widget.onTap ?? () => copyText(widget.link),
              titleTextStyle: widget.titleStyle,
              bodyTextStyle: widget.bodyStyle,
              bodyTextOverflow: widget.bodyTextOverflow,
              bodyMaxLines: widget.bodyMaxLines,
              showMultiMedia: widget.showMultimedia,
              bgColor: widget.backgroundColor,
              radius: widget.borderRadius ?? 12,
            )
          : LinkViewVertical(
              key: widget.key ?? Key(widget.link.toString()),
              url: widget.link,
              title: title!,
              description: desc!,
              imageUri: image!,
              onTap: widget.onTap ?? () => widget.doIt(),
              onLongPress: widget.onTap ?? () => widget.doIt(),
              titleTextStyle: widget.titleStyle,
              bodyTextStyle: widget.bodyStyle,
              bodyTextOverflow: widget.bodyTextOverflow,
              bodyMaxLines: widget.bodyMaxLines,
              showMultiMedia: widget.showMultimedia,
              bgColor: widget.backgroundColor,
              radius: widget.borderRadius ?? 12,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = _info as Metadata?;
    var height =
        (widget.displayDirection == UIDirection.uiDirectionHorizontal ||
                !widget.showMultimedia)
            ? ((MediaQuery.of(context).size.height) * 0.15)
            : ((MediaQuery.of(context).size.height) * 0.25);

    Widget loadingErrorWidget = Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
        color: Colors.grey[200],
      ),
      alignment: Alignment.center,
      child: Text(
        !_linkValid
            ? 'Invalid Link'
            : !_proxyValid
                ? 'Proxy URL is invalid. Kindly pass only if required'
                : 'Fetching data...',
      ),
    );

    if (_loading) {
      return (!_linkValid || !_proxyValid)
          ? loadingErrorWidget
          : (widget.placeholderWidget ?? loadingErrorWidget);
    }

    return _info == null
        ? widget.errorWidget ??
            _buildPlaceHolder(widget.backgroundColor!, height)
        : _buildLinkContainer(
            height,
            title:
                LinkAnalyzer.isNotEmpty(info!.title) ? info.title : _errorTitle,
            desc: LinkAnalyzer.isNotEmpty(info.desc) ? info.desc : _errorBody,
            image: LinkAnalyzer.isNotEmpty(info.image)
                ? ((widget.proxyUrl ?? '') + (info.image ?? ''))
                : _errorImage,
          );
  }
}
