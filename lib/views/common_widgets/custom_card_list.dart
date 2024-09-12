import 'package:bt_handheld/controllers/theme_manager/space_manager.dart';
import 'package:flutter/material.dart';

class CustomCardList extends StatelessWidget {
  const CustomCardList(
      {super.key,
      this.status,
      this.lokasi,
      this.lokasiRak,
      this.nomorKotak,
      this.epc,
      this.highlightColor,
      this.kodePelanggan,
      this.noSuratJalan,
      this.statusColor,
      this.statusIcon,
      this.isDetailList = false,
      this.isRak = false});
  final String? status;
  final String? lokasi;
  final String? lokasiRak;
  final String? nomorKotak;
  final String? epc;
  final String? kodePelanggan;
  final String? noSuratJalan;
  final Color? highlightColor;
  final bool isDetailList;
  final bool isRak;
  final Color? statusColor;
  final IconData? statusIcon;

  @override
  Widget build(BuildContext context) {
    if (isDetailList == true) {
      return Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          width: double.infinity,
          height: 180,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "nomor kotak",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        nomorKotak ?? '-',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(color: statusColor),
                    child: Icon(
                      statusIcon,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              10.0.spaceY,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "lokasi rak",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    lokasiRak ?? '-',
                    style: const TextStyle(fontSize: 16),
                  ),
                  4.0.spaceY,
                  const Text(
                    "epc",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    epc ?? '-',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (isRak == true) {
      return Container(
        decoration: BoxDecoration(
          color: highlightColor, // Highlight even items
          border: const Border(
              bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5)), // Example of additional decoration
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "lokasi",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    lokasi ?? '-',
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ],
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     const Text(
              //       "kode pelanggan",
              //       style: TextStyle(color: Colors.grey, fontSize: 12),
              //     ),
              //     Text(
              //       kodePelanggan ?? '-',
              //       style: const TextStyle(color: Colors.black, fontSize: 14),
              //     ),
              //     16.0.spaceY,
              //     const Text(
              //       "nomor surat jalan",
              //       style: TextStyle(color: Colors.grey, fontSize: 12),
              //     ),
              //     Text(
              //       noSuratJalan ?? '-',
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: highlightColor, // Highlight even items
          border: const Border(
              bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5)), // Example of additional decoration
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "nomor kotak",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    nomorKotak ?? '-',
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  16.0.spaceY,
                  const Text(
                    "status",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    status ?? '-',
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "kode pelanggan",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    kodePelanggan ?? '-',
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  16.0.spaceY,
                  const Text(
                    "nomor surat jalan",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    noSuratJalan ?? '-',
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
