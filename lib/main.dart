import 'package:flutter/material.dart';
import 'screens/add_job_screen.dart';
import 'models/job_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(JobTrackerApp());
}

class JobTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Job> jobs = [];
  String searchQuery = "";
  String selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    loadJobs();
  }

  Future<void> loadJobs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jobList = prefs.getStringList('jobs');

    if (jobList != null) {
      setState(() {
        jobs = jobList
            .map((job) => Job.fromMap(jsonDecode(job)))
            .toList();
      });
    }
  }

  Future<void> saveJobs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jobList =
        jobs.map((job) => jsonEncode(job.toMap())).toList();
    prefs.setStringList('jobs', jobList);
  }

  void addJob(Job job) {
    setState(() {
      jobs.add(job);
    });
    saveJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Tracker"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by company...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["All", "Applied", "Interview", "Rejected", "Selected"]
                    .map((status) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: ChoiceChip(
                            label: Text(status),
                            selected: selectedFilter == status,
                            onSelected: (_) {
                              setState(() {
                                selectedFilter = status;
                              });
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),

          Expanded(
            child: jobs.isEmpty
                ? Center(
                    child: Text(
                      "No Jobs Yet\nClick + to add",
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];

                      if (!job.company.toLowerCase().contains(searchQuery)) {
                        return SizedBox();
                      }

                      if (selectedFilter != "All" &&
                          job.status != selectedFilter) {
                        return SizedBox();
                      }

                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(
                            job.company,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${job.role} - ${job.location}\nStatus: ${job.status}",
                          ),
                          isThreeLine: true,

                          onTap: () async {
                            final updatedJob = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddJobScreen(job: job),
                              ),
                            );

                            if (updatedJob != null) {
                              setState(() {
                                jobs[index] = updatedJob;
                              });
                              saveJobs();
                            }
                          },

                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                jobs.removeAt(index);
                              });
                              saveJobs();
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddJobScreen()),
          );

          if (result != null) {
            addJob(result);
          }
        },
      ),
    );
  }
}