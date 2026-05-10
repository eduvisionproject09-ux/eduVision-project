# 🗺️ High-Level Roadmap

1. **Theme & Constant Integration**: Merged the custom Smart Notes dark theme into the main `app_constants.dart` under the `SmartNotesTheme` class to ensure centralized design control.
2. **Hierarchical Data Modeling**: Created `smart_notes_models.dart` containing a `NoteNode` class to support infinitely nested folders and files, mimicking VS Code's explorer.
3. **Sidebar Re-architecture**: Replaced the flat list in `smart_notes_left_sidebar.dart` with a recursive `TreeView`-style component that elegantly indents files and provides expand/collapse functionality for folders.
4. **Editor State Management**: Modified `smart_notes_screen.dart` to maintain both `currentTab` (Text, Rich, Draw, AI) and `isEditMode` state flags.
5. **Read/Edit Mode Implementation**: Updated `smart_notes_editor_area.dart` to dynamically render toolbars and input fields based on `isEditMode`. When saved, the note transitions to a clean, read-only preview.
6. **Navigation Linkage**: Linked the Smart Notes feature into the global `app_navigation.dart` sidebar.

---

# 🧠 Logical Descriptions

## Frontend Layer (Flutter)
- **Simple Description**: The Smart Notes screen is a standalone dashboard containing a left-side file explorer, a central document canvas, and an optional right-side AI chat panel. You can browse nested folders like you would on your computer. When you click "Save" on a note, all the editing buttons hide, leaving you with a distraction-free view of your content. Clicking "Edit" brings all the tools back.
- **Technical Description**: The UI relies on a `StatefulWidget` at the `SmartNotes` root level that hoists the `currentTab` (integer) and `isEditMode` (boolean) state. The `SmartNotesLeftSidebar` utilizes a recursive builder function `_buildTreeNode` that recursively consumes a `List<NoteNode>` to generate indented `InkWell` lists. The `SmartNotesEditorArea` employs conditional rendering (`if (isEditMode) ...`) to selectively unmount `TextField` and toolbar widgets, replacing them with a static `Text` preview when `isEditMode` evaluates to false.

## Backend Layer (Spring Boot / Service)
*(Currently UI Prototype Phase. Future integration will map `NoteNode` to `ResourceEntity` hierarchies).*

---

# 💻 Full Implementation Code

## 1. `lib/presentation/flutter_screens/smart_notes_models.dart`
```dart
class NoteNode {
  final String name;
  final bool isFolder;
  final List<NoteNode> children;
  bool isExpanded;

  NoteNode({
    required this.name,
    this.isFolder = false,
    this.children = const [],
    this.isExpanded = false,
  });
}
```

## 2. `lib/presentation/flutter_screens/smart_notes_left_sidebar.dart`
*(Please refer to the actual file in your repository for the complete recursive `_buildTreeNode` logic and UI setup).*

## 3. `lib/presentation/flutter_screens/smart_notes_editor_area.dart`
*(Please refer to the actual file in your repository for the conditional `isEditMode` rendering and tab switcher logic).*

## 4. `lib/presentation/flutter_screens/smart_notes_screen.dart`
*(Please refer to the actual file in your repository for the `StatefulWidget` composition).*

---

# 🛠️ Extra Steps
- **Future Database Schema**: When connecting this to the backend, the `Note` entity will require an optional `parentId` field (self-referencing relationship) to properly mirror the nested folder structure defined in `NoteNode`.
- **Supported Formats**: The system currently natively visually supports `.note` (Rich Canvas) and `.txt` (Raw Text). Future PDF integration will require a `.pdf` render branch in `SmartNotesEditorArea`.

---

# 📝 Summary
Data flows strictly top-down. The `SmartNotes` root widget manages the holistic state (Edit vs Read, Active Tab). These booleans and integers are passed down as parameters to the `EditorArea`. The `LeftSidebar` maintains its own localized state strictly for visually toggling the expansion of folders in the recursive file explorer tree.
