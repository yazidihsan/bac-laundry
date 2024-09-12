import 'dart:developer';

import 'package:bt_handheld/controllers/cubit/rack_cubit.dart';
import 'package:bt_handheld/controllers/services/dio_client.dart';
import 'package:bt_handheld/controllers/services/stock_opname_service.dart';
import 'package:bt_handheld/controllers/theme_manager/space_manager.dart';
import 'package:bt_handheld/views/common_widgets/custom_card_list.dart';
import 'package:bt_handheld/views/common_widgets/custom_loading_button.dart';
import 'package:bt_handheld/views/pages/Box/box_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RackPage extends StatefulWidget {
  const RackPage({super.key, required this.id, required this.name});
  final int id;
  final String name;

  @override
  State<RackPage> createState() => _RackPageState();
}

class _RackPageState extends State<RackPage> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  late RackCubit rackCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rackCubit = RackCubit(StockOpnameService());
    rackCubit.getAllRack();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    rackCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldState,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Daftar Rak",
          ),

          // automaticallyImplyLeading: false,
        ),
        body: BlocProvider(
          create: (context) => rackCubit,
          child: BlocListener<RackCubit, RackState>(
            listener: (context, state) {
              // if(state is RackFailed){
              //    scaffoldState.currentState!.showSnackBar(
              //     SnackBar(
              //       content: Text(state.errorMessage),
              //     ),
              //   );
              // }
              // TODO: implement listener
            },
            child: BlocBuilder<RackCubit, RackState>(
              builder: (context, state) {
                if (state is RackLoading) {
                  return const Center(
                    child: CustomLoadingButton(),
                  );
                }
                if (state is RackSuccess) {
                  final listRack = state.listRack;
                  log('data state: ${listRack.toString()}');

                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 80),
                    itemBuilder: (context, index) {
                      final dataLokasi = listRack[index].lokasi.toString();
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BoxPage(
                                        lokasi: dataLokasi,
                                      )));
                        },
                        child: CustomCardList(
                          isRak: true,
                          lokasi: dataLokasi,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => 8.0.spaceY,
                    itemCount: listRack.length,
                  );
                }
                return Container();
              },
            ),
          ),
        ));
  }
}
