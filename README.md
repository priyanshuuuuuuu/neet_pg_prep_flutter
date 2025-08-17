# NEET PG Prep Tracker - Flutter App

A beautiful, modern Flutter application designed to help medical students track their NEET PG preparation progress with real-time updates and an intuitive user interface.

## ✨ Features

### 🎯 **Topic Checklist**
- **8 Medical Subjects**: Anatomy, Physiology, Biochemistry, Pathology, Microbiology, Pharmacology, Forensic Medicine, Community Medicine
- **Subtopics Tracking**: Each subject has detailed subtopics for comprehensive coverage
- **Real-time Progress**: Progress bars update automatically as you check off topics
- **Visual Feedback**: Color-coded progress indicators (Green: 80%+, Orange: 60-79%, Yellow: 40-59%, Red: <40%)

### 🔔 **Smart Reminders**
- **Add Reminders**: Set study reminders with title, message, date, and time
- **Priority Management**: Mark reminders as completed or pending
- **Overdue Alerts**: Visual indicators for overdue reminders
- **Tabbed Interface**: Separate views for pending and completed reminders
- **Delete Functionality**: Remove reminders you no longer need

### 📊 **Progress Tracker**
- **Overall Progress**: Visual progress bar showing completion percentage
- **Study Streak**: Track consecutive days of study activity
- **Subject Breakdown**: Individual progress for each medical subject
- **Recent Activity**: View completed goals and mock test results
- **Auto-refresh**: Progress updates automatically reflect changes

### 🎯 **Study Goals**
- **Goal Setting**: Create study goals with title, description, and deadline
- **Priority Levels**: High, Medium, Low priority with color coding
- **Deadline Tracking**: Visual alerts for upcoming and overdue deadlines
- **Progress Monitoring**: Mark goals as completed or reset them
- **Smart Notifications**: Days-until-deadline indicators

### 📅 **Study Schedule**
- **Weekly Planning**: Schedule study sessions for each day of the week
- **Time Management**: Set specific times for each study topic
- **Today's Focus**: Special highlighting for today's schedule
- **Flexible Editing**: Add, modify, or delete schedule items
- **Visual Organization**: Clean, expandable day-by-day view

### 📝 **Mock Tests**
- **Performance Tracking**: Record mock test results with detailed metrics
- **Score Analysis**: Track correct, incorrect, and unattempted questions
- **Subject Categorization**: Organize tests by medical subject
- **Progress Visualization**: Performance charts and statistics
- **Notes & Comments**: Add personal notes for each test

## 🚀 **Key Benefits**

### **Automatic Updates**
- **Real-time Progress**: All changes reflect immediately across the app
- **Live Calculations**: Progress percentages update automatically
- **Streak Tracking**: Study streaks update based on your activity
- **No Manual Refresh**: UI stays synchronized with your data

### **Beautiful Design**
- **Modern Material Design**: Clean, intuitive interface
- **Gradient Backgrounds**: Eye-catching visual elements
- **Responsive Layout**: Works perfectly on all screen sizes
- **Color-coded Elements**: Easy visual identification
- **Smooth Animations**: Pleasant user experience

### **Data Persistence**
- **Local Storage**: All data saved locally on your device
- **No Internet Required**: Works offline
- **Secure**: Your study data stays private
- **Backup Ready**: Easy to export/import data

## 🛠️ **Technical Features**

- **Flutter Framework**: Cross-platform compatibility
- **Provider Pattern**: Efficient state management
- **Shared Preferences**: Local data persistence
- **Responsive Design**: Adapts to different screen sizes
- **Material Design 3**: Latest design standards

## 📱 **Getting Started**

### **Prerequisites**
- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Android Emulator or Physical Device

### **Installation**
1. Clone the repository
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Connect your device or start an emulator
5. Run `flutter run` to launch the app

### **Dependencies**
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.5
  shared_preferences: ^2.5.3
  intl: ^0.20.2
  flutter_local_notifications: ^19.4.0
```

## 🎨 **UI/UX Highlights**

### **Home Screen**
- **Welcome Message**: Personalized greeting for Ruchi
- **Progress Overview**: Large, prominent progress card
- **Quick Stats**: At-a-glance information about reminders, goals, and today's schedule
- **Navigation Grid**: Beautiful card-based menu system

### **Color Scheme**
- **Primary Blue**: #2196F3 for main elements
- **Success Green**: #4CAF50 for completed items
- **Warning Orange**: #FF9800 for medium priority
- **Alert Red**: #F44336 for high priority/overdue items
- **Neutral Grey**: #607D8B for schedule items

### **Interactive Elements**
- **Floating Action Buttons**: Easy access to add new items
- **Expansion Tiles**: Collapsible sections for better organization
- **Tabbed Interfaces**: Organized content presentation
- **Form Validation**: User-friendly input validation
- **Confirmation Dialogs**: Safe deletion with confirmation

## 🔄 **Data Flow**

1. **User Action**: Check off a topic, add reminder, etc.
2. **Provider Update**: AppDataProvider processes the change
3. **Data Persistence**: Changes saved to local storage
4. **UI Refresh**: All screens automatically update
5. **Progress Recalculation**: Overall progress and statistics update

## 📊 **Progress Calculation**

- **Topic Progress**: Based on completed subtopics vs. total
- **Overall Progress**: Weighted average across all subjects
- **Study Streak**: Consecutive days with study activity
- **Mock Test Performance**: Average scores and trends

## 🎯 **Best Practices Implemented**

- **Separation of Concerns**: Models, providers, and UI separated
- **Reactive Programming**: UI automatically responds to data changes
- **Error Handling**: Form validation and user feedback
- **Accessibility**: Clear labels and intuitive navigation
- **Performance**: Efficient data loading and caching

## 🔮 **Future Enhancements**

- **Cloud Sync**: Backup data to cloud storage
- **Notifications**: Push reminders for scheduled study sessions
- **Analytics**: Detailed study pattern analysis
- **Social Features**: Share progress with study groups
- **Offline Mode**: Enhanced offline functionality

## 📞 **Support**

For questions or issues:
1. Check the code comments for implementation details
2. Review the provider pattern for state management
3. Examine the model classes for data structure
4. Look at the UI components for styling examples

## 🎉 **Conclusion**

This Flutter app provides a comprehensive, beautiful, and functional solution for NEET PG preparation tracking. With automatic updates, real-time progress tracking, and an intuitive interface, it helps medical students stay organized and motivated throughout their preparation journey.

The app demonstrates modern Flutter development practices, including:
- Clean architecture with provider pattern
- Beautiful Material Design 3 implementation
- Efficient state management
- Local data persistence
- Responsive and accessible UI

Start using it today to take your NEET PG preparation to the next level! 🚀📚
