import 'package:flutter/material.dart';
import '../models/job_model.dart';

class AddJobScreen extends StatefulWidget {
  final Job? job;

  AddJobScreen({this.job});

  @override
  _AddJobScreenState createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final companyController = TextEditingController();
  final roleController = TextEditingController();
  final locationController = TextEditingController();

  String selectedStatus = "Applied";

  @override
  void initState() {
    super.initState();

    if (widget.job != null) {
      companyController.text = widget.job!.company;
      roleController.text = widget.job!.role;
      locationController.text = widget.job!.location;
      selectedStatus = widget.job!.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job == null ? "Add Job" : "Edit Job"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: companyController,
              decoration: InputDecoration(labelText: "Company Name"),
            ),
            TextField(
              controller: roleController,
              decoration: InputDecoration(labelText: "Role"),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: "Location"),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedStatus,
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
              items: ["Applied", "Interview", "Rejected", "Selected"]
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final job = Job(
                  company: companyController.text,
                  role: roleController.text,
                  location: locationController.text,
                  status: selectedStatus,
                );

                Navigator.pop(context, job);
              },
              child: Text("Save Job"),
            ),
          ],
        ),
      ),
    );
  }
}