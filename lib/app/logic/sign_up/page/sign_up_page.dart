import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../logic.dart';
import '../sign_up.dart';

class SignUpPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (context) => SignUpPage());

  @override
  Widget build(BuildContext context) {
    final builder =
        BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return Wrap(
        runSpacing: 12,
        children: [
          CachedNetworkImage(
            imageUrl: state.user.avatar,
            width: 96,
            height: 96,
          )
              .ripple()
              .gestures(
                  onTap: () => context.read<SignUpBloc>().add(SignUpRandom()))
              .clipRRect(all: 96)
              .center(),
          Text('${state.user.address}').center(),
          ElevatedButton(
                  onPressed: () =>
                      context.read<SignUpBloc>().add(SignUpSubmitted()),
                  child: Text('开始聊天'))
              .center()
        ],
      );
    });

    return Scaffold(
      body: builder.safeArea().center(),
    ).parent(({required child}) => BlocProvider(
          create: (context) => SignUpBloc(repository: context.read()),
          child: child,
        ));
  }
}
