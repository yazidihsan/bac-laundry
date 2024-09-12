// import 'package:bt_handheld/pages/Rfid/rfid_page.dart';
// import 'package:bt_handheld/services/blue_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';

// class SecondPage extends StatefulWidget {
//   const SecondPage({Key? key}) : super(key: key);

//   @override
//   State<SecondPage> createState() => _SecondPageState();
// }

// class _SecondPageState extends State<SecondPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Bluetooth Handheld'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             StreamBuilder<bool>(
//               stream: BlueService.flutterBlue.isScanning,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   final isScanning = snapshot.data;

//                   return ElevatedButton(
//                     onPressed: isScanning ?? false
//                         ? () async {
//                             await BlueService.stopScan();
//                           }
//                         : () async {
//                             await BlueService.startScan();
//                           },
//                     child: isScanning ?? false
//                         ? const Text('Stop Search Devices')
//                         : const Text('Start Search Devices'),
//                   );
//                 }
//                 return Container();
//               },
//             ),
//             StreamBuilder<List<ScanResult>>(
//               stream: BlueService.flutterBlue.scanResults,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   final scanResults = snapshot.data;

//                   return Column(
//                     children: [
//                       Text('${scanResults?.length}'),
//                       ListView.builder(
//                         shrinkWrap: true,
//                         physics: const ScrollPhysics(),
//                         itemCount: scanResults?.length,
//                         itemBuilder: (context, index) {
//                           final bluetoothDevice = scanResults?[index].device;

//                           return StreamBuilder<BluetoothDeviceState>(
//                               stream: bluetoothDevice?.state,
//                               builder: (context, snapshot) {
//                                 if (snapshot.hasData) {
//                                   final deviceState = snapshot.data;

//                                   return ListTile(
//                                     title: Text(bluetoothDevice?.name ?? '-'),
//                                     subtitle:
//                                         Text(bluetoothDevice?.id.id ?? '-'),
//                                     // trailing: CircleAvatar(
//                                     //   radius: 10,
//                                     //   backgroundColor: deviceState ==
//                                     //           BluetoothDeviceState.connected
//                                     //       ? Colors.green
//                                     //       : Colors.red,
//                                     // ),
//                                     onTap: deviceState ==
//                                             BluetoothDeviceState.disconnected
//                                         ? () {
//                                             bluetoothDevice
//                                                 ?.connect()
//                                                 .then((value) {
//                                               BlueService.stopScan();

//                                               Navigator.of(context)
//                                                   .push(MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     const RfidPage(),
//                                               ));
//                                             });
//                                           }
//                                         : () async {
//                                             await bluetoothDevice?.disconnect();
//                                           },
//                                   );
//                                 }
//                                 return Container();
//                               });
//                         },
//                       ),
//                     ],
//                   );
//                 }
//                 return Container();
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
