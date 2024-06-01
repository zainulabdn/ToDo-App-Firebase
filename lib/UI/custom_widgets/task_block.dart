import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../Core/Constants/colors.dart';

class TaskBlock extends StatelessWidget {
  final String title;
  final bool done;
  final bool latedone;
  final DateTime dueDate;
  final DateTime createDate;
  final VoidCallback onDelete;
  final VoidCallback onDone;
  final VoidCallback onLateDone;

  final String description;

  const TaskBlock(
      {super.key,
      required this.title,
      required this.description,
      required this.onDelete,
      required this.done,
      required this.latedone,
      required this.onLateDone,
      required this.onDone,
      required this.dueDate,
      required this.createDate});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(15), // Set the border radius
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: Get.width * 0.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: done || latedone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          description,
                          style: TextStyle(
                            decoration: done || latedone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Start: ${DateFormat('dd-MM-yyyy').format(createDate)} at ${DateFormat('hh:mm a').format(createDate)}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'End: ${DateFormat('dd-MM-yyyy').format(dueDate)} at ${DateFormat('hh:mm a').format(dueDate)}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      DateTime.now().isAfter(dueDate) && !done
                          ? IconButton(
                              color: kPrimaryColor,
                              onPressed: onLateDone,
                              icon: Icon(
                                  done
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: Colors.red),
                            )
                          : IconButton(
                              color: kPrimaryColor,
                              onPressed: onDone,
                              icon: Icon(done
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank),
                            ),
                      IconButton(
                          onPressed: onDelete,
                          icon: const Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.red,
                          )),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              if (DateTime.now().isAfter(dueDate) && !done)
                Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(5),
                  child: const Text(
                    'Expired',
                    style: TextStyle(color: Colors.white),
                  ),
                )
            ],
          ),
        ));
  }
}
