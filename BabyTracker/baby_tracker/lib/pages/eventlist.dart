import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:baby_tracker/widgets/event_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../service/database_service.dart';

class EventList extends StatefulWidget {
  const EventList({
    Key? key,
    required this.babyName,
    required this.babyId,
    required this.userName,
  }) : super(key: key);
  final String babyName;
  final String babyId;
  final String userName;

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  Stream<QuerySnapshot>? events;

  TextEditingController searchController = TextEditingController();
  String searchText = '';
  String typeFilter = 'All';

  List<DocumentSnapshot> documents = [];

  @override
  void initState() {
    super.initState();
    getEventData();
  }

  getEventData() {
    DatabaseService().getEventData(widget.babyId).then((val) {
      setState(() {
        events = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: AppTextTheme.subtitle.copyWith(
                color: AppColorScheme.lightGray,
              ),
              prefixIcon: Icon(Icons.search),
              filled: true,
            ),
          ),
          DropdownButton(
            value: typeFilter,
            items: [
              DropdownMenuItem(
                value: 'All',
                child: Text('All',
                    style: AppTextTheme.body.copyWith(
                      color: AppColorScheme.white,
                    ))),
              DropdownMenuItem(
                value: 'Diaper Change',
                child: Text('Diaper Change',
                    style: AppTextTheme.body.copyWith(
                      color: AppColorScheme.white,
                    ))),
              DropdownMenuItem(
                value: 'Meal Time',
                child: Text('Meal Time',
                    style: AppTextTheme.body.copyWith(
                      color: AppColorScheme.white,
                    ))),
              DropdownMenuItem(
                value: 'Sleep Time',
                child: Text('Sleep Time',
                    style: AppTextTheme.body.copyWith(
                      color: AppColorScheme.white,
                    ))),
              DropdownMenuItem(
                value: 'Incidents',
                child: Text('Incidents',
                    style: AppTextTheme.body.copyWith(
                      color: AppColorScheme.white,
                    ))),
              DropdownMenuItem(
                value: 'Appointments',
                child: Text('Appointments',
                    style: AppTextTheme.body.copyWith(
                      color: AppColorScheme.white,
                    ))),
            ],
            onChanged: (String? value) {
              setState(() {
                typeFilter = value!;
              });
            },
          ),
          Expanded(
            child: StreamBuilder(
                stream: events,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    documents = snapshot.data.docs;
                    if (searchText.isNotEmpty) {
                      documents = documents.where((element) {
                        return element
                            .get('task')
                            .toString()
                            .toLowerCase()
                            .contains(searchText.toLowerCase());
                      }).toList();
                    }
                    if (typeFilter != 'All') {
                      documents = documents.where((element) {
                        return element
                            .get('type')
                            .toString()
                            == typeFilter;
                      }).toList();
                    }
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        return EventCard(
                            taskName: documents[index]['task'],
                            taskType: documents[index]['type'],
                            taskDescription: documents[index]['description'],
                            taskStartTime:
                                documents[index]['startTime'].toDate(),
                            taskEndTime: documents[index]['endTime'].toDate(),
                            calories: documents[index]['calories'],
                            babyExcreta: documents[index]['babyExcreta'],
                            duration: documents[index]['duration']);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'No data available right now',
                        style: AppTextTheme.body.copyWith(
                          color: AppColorScheme.white,
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColorScheme.white,
                      ),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
