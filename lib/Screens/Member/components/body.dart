import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:thai7merchant/Screens/Member/member_add.dart';
import 'package:thai7merchant/bloc/member/member_bloc.dart';
import 'package:thai7merchant/components/background_main.dart';
import 'package:thai7merchant/components/textfield_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thai7merchant/model/member.dart';
import 'package:thai7merchant/util.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Member> _member = [];

  final ScrollController _scrollController = ScrollController();

  int _perPage = 10;
  String _search = "";

  @override
  initState() {
    super.initState();
    context.read<MemberBloc>().add(ListMemberLoad(
        page: 0, perPage: _perPage, search: _search, nextPage: true));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      MemberBloc memberBloc = context.read<MemberBloc>();
      MemberLoadSuccess memberLoadSuccess;

      if (memberBloc.state is MemberLoadSuccess) {
        memberLoadSuccess = (memberBloc.state as MemberLoadSuccess);
        if (memberLoadSuccess.page!.page < memberLoadSuccess.page!.totalPage) {
          memberBloc.add(ListMemberLoad(
              page: memberLoadSuccess.page!.page + 1,
              perPage: _perPage,
              search: _search,
              nextPage: false));
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return MultiBlocListener(
      listeners: [
        BlocListener<MemberBloc, MemberState>(
          listener: (context, state) {
            if (state is MemberLoadSuccess) {
              if (state.member.isNotEmpty) {
                //_member = state.member;
              }
            }
          },
        ),
      ],
      child: BackgroudMain(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                child: TextFieldSearch(
                  onChange: (value) {},
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Expanded(
                        child: BlocBuilder<MemberBloc, MemberState>(
                          builder: (context, state) {
                            return (state is MemberInProgress)
                                ? Container(
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: const CircularProgressIndicator(),
                                  )
                                : (state is MemberLoadSuccess)
                                    ? ListView.builder(
                                        controller: _scrollController,
                                        itemCount: _member.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            elevation: 1,
                                            child: ListTile(
                                              onTap: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MemberAdd(
                                                      guidfixed: state
                                                          .member[index]
                                                          .guidfixed,
                                                    ),
                                                  ),
                                                );
                                              },
                                              leading: const CircleAvatar(
                                                radius: 35.0,
                                                backgroundImage: AssetImage(
                                                    'assets/img/vficon.png'),
                                              ),
                                              title: RichText(
                                                text: TextSpan(
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: _member[index]
                                                            .name),
                                                    TextSpan(
                                                      text: _member[index]
                                                                  .personaltype ==
                                                              0
                                                          ? ' (ผู้ซื้อ)'
                                                          : ' (ผู้ขาย)',
                                                      style: TextStyle(
                                                        color: _member[index]
                                                                    .personaltype ==
                                                                0
                                                            ? Colors.green
                                                            : Colors.orange,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              subtitle: Text(
                                                'โทร: ${_member[index].telephone.toString()}',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              trailing: const Icon(
                                                Icons
                                                    .keyboard_arrow_right_sharp,
                                              ),
                                            ),
                                          );
                                        })
                                    : (state is MemberLoadFailed)
                                        ? const Text(
                                            'ไม่เจอข้อมูล',
                                            style: TextStyle(fontSize: 24),
                                          )
                                        : Container();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
