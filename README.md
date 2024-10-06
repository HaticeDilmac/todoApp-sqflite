# ToDo App

## Description

The ToDo App is a simple task management application built with Flutter, allowing users to create, update, view, and delete tasks. The app uses the `sqflite` package for local database management, ensuring that tasks are stored persistently on the device. It also features a user-friendly interface for task management.

## Features

- **Create Task**: Easily add new tasks to your to-do list.
- **View Tasks**: View all tasks with their creation and updated timestamps.
- **Update Task**: Modify existing tasks seamlessly.
- **Delete Task**: Remove tasks with a confirmation prompt to prevent accidental deletions.
- **Persistent Storage**: Task data is stored locally on the device using `sqflite` for offline access.

## Screenshots


## Installation

### Prerequisites

- Flutter SDK
- Dart SDK

### Steps to Install

1. Clone the repository:
   ```bash
   git clone <repo_url>
   ```

2. Navigate to the project directory:
   ```bash
   cd todo_app
   ```

3. Install the necessary packages:
   ```bash
   flutter pub get
   ```

4. Run the application:
   ```bash
   flutter run
   ```

## Usage

### Adding Tasks

1. Tap the **+ Add Task** button on the home screen.
2. Enter the task title in the dialog.
3. Click **Save** to add the task.

### Viewing Tasks

- All tasks are displayed on the home screen with their respective timestamps.

### Updating Tasks

1. Tap on a task from the list.
2. In the update dialog, enter the new task title.
3. Click **Save** to update the task.

### Deleting Tasks

1. Tap the delete icon next to the task.
2. Confirm the deletion in the dialog that appears.

## Code Structure

- **todo.dart**: Defines the data model for tasks.
- **todo_db.dart**: Manages database operations using `sqflite` for tasks.
- **todo_widget.dart**: Contains UI components related to tasks.
- **todo_page.dart**: Main page displaying the list of tasks and managing interactions.

## Database

This app uses `sqflite` for local database management. The database is initialized when the app starts and tasks are saved, updated, and deleted using SQL operations provided by `sqflite`.

- **sqflite**: A Flutter plugin for SQLite, providing persistent storage for structured data. You can read more about it [here](https://pub.dev/packages/sqflite).

## Contributing

Contributions are welcome! Please create a pull request for any enhancements or bug fixes.

## License

This project is licensed under the [MIT License](LICENSE).

---

This version includes the mention of `sqflite` and its role in managing the local database. Let me know if anything else needs adjustment!