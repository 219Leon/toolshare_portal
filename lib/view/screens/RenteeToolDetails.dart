import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:toolshare_portal/view/screens/RentPayment.dart';
import 'package:toolshare_portal/view/shared/EnterExitRoute.dart';
import '../../models/user.dart';
import '../../models/tools.dart';
import 'package:toolshare_portal/config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RenteeToolDetails extends StatefulWidget {
  final User user;
  final Tool tool;
  final User renter;
  const RenteeToolDetails(
      {super.key,
      required this.user,
      required this.tool,
      required this.renter});

  @override
  State<RenteeToolDetails> createState() => _renteeToolDetailsState();
}

class _renteeToolDetailsState extends State<RenteeToolDetails> {
  late double screenHeight, screenWidth, resWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.90;
    }
    return Scaffold(
      appBar:
          AppBar(title: Text("Details for ${widget.tool.toolName.toString()}")),
      body: Column(
        children: [
          Card(
              elevation: 8,
              child: Container(
                  height: screenHeight / 4,
                  width: resWidth / 1.2,
                  child: CachedNetworkImage(
                    imageUrl:
                        "${Config.SERVER}/assets/toolimages/${widget.tool.toolId}.png",
                    width: resWidth,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ))),
          const SizedBox(height: 10),
          Text(widget.tool.toolName.toString(),
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            width: screenWidth - 16,
            child: Table(
              border: TableBorder.all(
                  color: Colors.black, style: BorderStyle.none, width: 1),
              columnWidths: const {
                0: FixedColumnWidth(80),
                1: FixedColumnWidth(10),
                2: FixedColumnWidth(180),
              },
              children: [
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Description', style: TextStyle(fontSize: 13))
                      ]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.tool.toolDesc.toString(),
                            style: const TextStyle(fontSize: 13)),
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Price', style: TextStyle(fontSize: 13))
                      ]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "RM ${double.parse(widget.tool.toolRentPrice.toString()).toStringAsFixed(2)} per hour",
                            style: const TextStyle(fontSize: 13)),
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Delivery Fees', style: TextStyle(fontSize: 13))
                      ]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "RM ${double.parse(widget.tool.toolDelivery.toString()).toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 13)),
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Quantity', style: TextStyle(fontSize: 13))
                      ]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.tool.toolQty.toString(),
                            style: const TextStyle(fontSize: 13)),
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Locality', style: TextStyle(fontSize: 13))
                      ]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.tool.toolLocal}",
                            style: const TextStyle(fontSize: 13)),
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Renter Name', style: TextStyle(fontSize: 13))
                      ]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.renter.name}",
                            style: const TextStyle(fontSize: 13))
                      ]),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(Size(resWidth / 2, 50)),
              ),
              onPressed: _rentPayment,
              child: const Text(
                'Reserve Tool',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 25),
          Expanded(
              child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Card(
                child: SizedBox(
                    child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    iconSize: 35,
                    onPressed: _makePhoneCall,
                    icon: const Icon(Icons.call)),
                IconButton(
                    iconSize: 35,
                    onPressed: _whatsApp,
                    icon: const Icon(Icons.whatsapp)),
                IconButton(
                    iconSize: 35,
                    onPressed: _makeSmS,
                    icon: const Icon(Icons.message)),
                IconButton(
                    iconSize: 35,
                    onPressed: _onRoute,
                    icon: const Icon(Icons.map)),
                IconButton(
                    iconSize: 35,
                    onPressed: _onShowMap,
                    icon: const Icon(Icons.maps_home_work)),
              ],
            ))),
          )),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: widget.renter.phone,
    );
    await launchUrl(launchUri);
  }

  Future<void> _makeSmS() async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: widget.renter.phone,
    );
    await launchUrl(launchUri);
  }

  Future<void> _onRoute() async {
    final Uri launchUri = Uri(
        scheme: 'https',
        path:
            "www.google.com/maps/@${widget.tool.toolLat},${widget.tool.toolLng}20z");
    await launchUrl(launchUri);
  }

  Future<void> _whatsApp() async {
    final Uri launchUri =
        Uri(scheme: 'https', path: "wa.me/+6${widget.renter.phone}");
    await launchUrl(launchUri);
  }

  int generateIds() {
    var rng = Random();
    int randomInt;
    randomInt = rng.nextInt(100);
    return randomInt;
  }

  void _onShowMap() {
    double lat = double.parse(widget.tool.toolLat.toString());
    double lng = double.parse(widget.tool.toolLng.toString());
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    int markerIdVal = generateIds();
    MarkerId markerId = MarkerId(markerIdVal.toString());
    final Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(
        lat,
        lng,
      ),
    );
    markers[markerId] = marker;

    CameraPosition campos = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 16.4746,
    );
    Completer<GoogleMapController> ncontroller =
        Completer<GoogleMapController>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Location",
            style: TextStyle(),
          ),
          content: Container(
            color: Colors.blueAccent,
            height: screenHeight,
            width: screenWidth,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: campos,
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller) {
                ncontroller.complete(controller);
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _rentPayment() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RentPayment(
          user: widget.user,
          tool: widget.tool,
          renter: widget.renter,
        ),
      ),
    );
  }
}
