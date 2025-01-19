import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vatsalya_clinic/components/AppLabelValue.dart';
import 'package:vatsalya_clinic/screens/reference/reference_add_dialog.dart';
import 'package:vatsalya_clinic/screens/reference/reference_bloc.dart';
import 'package:vatsalya_clinic/screens/reference/reference_event.dart';
import 'package:vatsalya_clinic/screens/reference/reference_state.dart';
import 'package:vatsalya_clinic/utils/app_utils.dart';

class ReferenceAddList extends StatelessWidget {
  const ReferenceAddList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var block = ReferenceBloc();
        block.add(GetReferenceList());
        return block;
      },
      child: BlocConsumer<ReferenceBloc, ReferenceState>(
          listener: (context, state) {
        if (state is ReferenceAddFailure) {
          showSnackBar(state.error, context);
        } else if (state is ReferenceAddedSuccessfully) {
          showSnackBar("Reference Added Successfully.", context);
        }
      }, builder: (context, state) {
        return state is ReferenceFailure
            ? Center(child: Text(state.error))
            : state is ReferenceSuccess
                ? state.referenceList.isEmpty
                    ? Center(
                        child: TextButton(
                            onPressed: () async {
                              var referenceName = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const ReferenceAddDialog();
                                  });
                              if (referenceName != null) {
                                BlocProvider.of<ReferenceBloc>(context)
                                    .add(AddReference(referenceName));
                              }
                            },
                            child: const Text("Add Reference")))
                    : Scaffold(
                        floatingActionButton: InkWell(
                          onTap: () async {
                            var referenceName = await showDialog(
                                context: context,
                                builder: (context) {
                                  return const ReferenceAddDialog();
                                });
                            if (referenceName != null) {
                              BlocProvider.of<ReferenceBloc>(context)
                                  .add(AddReference(referenceName));
                            }
                          },
                          child: Card(
                            shape: const CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            child: Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                  colors: [
                                    Colors.blue,
                                    Colors.green
                                  ], // Gradient colors
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )),
                                child: const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(
                                    Icons.add_circle,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ),
                        body: ListView.builder(
                            itemCount: state.referenceList.length,
                            itemBuilder: (context, index) {
                              var reference = state.referenceList[index];
                              return Card(
                                  margin: const EdgeInsets.only(
                                      top: 16, left: 16, right: 16),
                                  clipBehavior: Clip.antiAlias,
                                  color: Colors.white,
                                  child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: AppLabelValue(
                                          label: "name",
                                          value: reference.name)));
                            }),
                      )
                : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
