import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventora/controllers/payment_controller.dart';
import 'package:eventora/utils/custom_flutter_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Widgets/custom_appbar.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_textfield.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage(
      {Key? key,
      required this.description,
      required this.title,
      required this.schedule,
      required this.fees,
      required this.slug,
      required this.venue,
      required this.images})
      : super(key: key);
  final String? description;
  final String? title;
  final String? schedule;
  final int? fees;
  final String? venue;
  final String? slug;
  final List<dynamic>? images;
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final FocusNode _ccNumberNode = FocusNode();
  final FocusNode _ccCVCNode = FocusNode();
  final FocusNode _ccExpiryYearNode = FocusNode();
  final FocusNode _ccExpiryMonthNode = FocusNode();

  final TextEditingController _ccNumberController = TextEditingController();
  final TextEditingController _ccCVCController = TextEditingController();
  final TextEditingController _ccExpiryYearController = TextEditingController();
  final TextEditingController _ccExpiryMonthController =
      TextEditingController();

  late String? cloudFrontUri = '';

  void fetchCloudFrontUri() async {
    await dotenv.load(fileName: ".env");
    setState(() {
      cloudFrontUri = dotenv.env['CLOUDFRONT_URI'];
    });
  }

  @override
  void initState() {
    if (mounted) {
      fetchCloudFrontUri();
    }
    super.initState();
  }

  @override
  void dispose() {
    _ccNumberController.dispose();
    _ccCVCController.dispose();
    _ccExpiryYearController.dispose();
    _ccExpiryMonthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Payment',
      ),
      body: cloudFrontUri == ''
          ? Center(
              child: SpinKitCircle(
                size: 50.0,
                color: Colors.grey[700],
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: 250,
                              maxWidth: (MediaQuery.of(context).size.width)),
                          child: CarouselSlider.builder(
                            itemCount: widget.images!.length,
                            itemBuilder: (context, index, realIndex) {
                              return CachedNetworkImage(
                                  imageUrl:
                                      '$cloudFrontUri${widget.images![index]}',
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                  width: (MediaQuery.of(context).size.width),
                                  height: 250);
                            },
                            options: CarouselOptions(
                              height: 250,
                              autoPlay: false,
                              viewportFraction: 1,
                            ),
                          )),
                      const SizedBox(height: 15.0),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.title!,
                          style: TextStyle(
                              color: Colors.grey[600],
                              letterSpacing: 2.0,
                              fontSize: 26.0),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Description:',
                          style: TextStyle(
                              color: Colors.grey[600],
                              letterSpacing: 2.0,
                              fontSize: 14.0),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.description!,
                          style: TextStyle(
                              color: Colors.grey[700],
                              letterSpacing: 2.0,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.fade),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Schedule:',
                          style: TextStyle(
                              color: Colors.grey[600],
                              letterSpacing: 2.0,
                              fontSize: 14.0),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.schedule!,
                          style: TextStyle(
                            color: Colors.grey[700],
                            letterSpacing: 2.0,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Fees:',
                          style: TextStyle(
                              color: Colors.grey[600],
                              letterSpacing: 1.0,
                              fontSize: 14.0),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.fees!.toString(),
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  letterSpacing: 1.0,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.fade),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Venue:',
                          style: TextStyle(
                              color: Colors.grey[600],
                              letterSpacing: 1.0,
                              fontSize: 14.0),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.venue!,
                          style: TextStyle(
                              color: Colors.grey[700],
                              letterSpacing: 1.0,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.clip),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: Divider(
                          color: Colors.grey[600],
                        ),
                      ),
                      CustomTextField(
                        onChanged: (value) => value,
                        textAlign: TextAlign.center,
                        label: 'CC Number',
                        focusNode: _ccNumberNode,
                        letterSpacing: 1.0,
                        controller: _ccNumberController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(16)
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: CustomTextField(
                              onChanged: (value) => value,
                              textAlign: TextAlign.center,
                              label: 'CVC',
                              focusNode: _ccCVCNode,
                              letterSpacing: 1.0,
                              controller: _ccCVCController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                LengthLimitingTextInputFormatter(3)
                              ],
                            ),
                          ),
                          const SizedBox(width: 15.0),
                          Expanded(
                            child: CustomTextField(
                              onChanged: (value) => value,
                              textAlign: TextAlign.center,
                              label: 'Month',
                              focusNode: _ccExpiryMonthNode,
                              letterSpacing: 1.0,
                              controller: _ccExpiryMonthController,
                            ),
                          ),
                          const SizedBox(width: 15.0),
                          Expanded(
                            child: CustomTextField(
                              onChanged: (value) => value,
                              textAlign: TextAlign.center,
                              label: 'Year',
                              focusNode: _ccExpiryYearNode,
                              letterSpacing: 1.0,
                              controller: _ccExpiryYearController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      CustomButton(
                        backgroundColor: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10.0),
                        onPressed: () {
                          pay();
                        },
                        padding: const EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        text: 'Pay',
                        elevation: 0.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void pay() {
    if (_ccExpiryMonthController.text.isEmpty) {
      return _ccExpiryMonthNode.requestFocus();
    }

    if (_ccNumberController.text.isEmpty) {
      return _ccNumberNode.requestFocus();
    }

    if (_ccExpiryYearController.text.isEmpty) {
      return _ccExpiryYearNode.requestFocus();
    }

    if (_ccCVCController.text.isEmpty) {
      return _ccCVCNode.requestFocus();
    }

    Map<String, dynamic> paymentData = {
      'card_no': _ccNumberController.text,
      'ccExpiryMonth': _ccExpiryMonthController.text,
      'ccExpiryYear': _ccExpiryYearController.text,
      'cvvNumber': _ccCVCController.text
    };

    PaymentController().pay(paymentData, widget.slug!);

    _ccNumberController.clear();
    _ccExpiryMonthController.clear();
    _ccExpiryYearController.clear();
    _ccCVCController.clear();

    CustomFlutterToast.showOkayToast('Payment successful.');

    return;
  }
}
