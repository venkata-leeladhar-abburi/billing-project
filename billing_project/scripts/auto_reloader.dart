import 'dart:io';
import 'dart:convert';
import 'dart:async';

void main() async {
  print('Starting flutter run with auto-reload on save...');
  
  // Note: Replace the device ID below with the current iOS simulator ID or leave it out to use the default device.
  final process = await Process.start(
    'flutter', 
    ['run', '-d', '87E30060-8B89-40CE-BE09-DCBEB4DCD827'], 
    runInShell: true
  );

  // Pipe stdout and stderr so we can see the flutter output
  process.stdout.transform(utf8.decoder).listen((data) {
    stdout.write(data);
  });
  
  process.stderr.transform(utf8.decoder).listen((data) {
    stderr.write(data);
  });
  
  // Pipe stdin so interactive commands (like 'q', 'r', 'R') still work manually
  stdin.listen((data) {
    process.stdin.add(data);
  });

  // Watch the lib directory for file changes
  final libDir = Directory('lib');
  Timer? debounceTimer;
  
  libDir.watch(recursive: true).listen((event) {
    if (event.path.endsWith('.dart')) {
      debounceTimer?.cancel();
      // Use a debounce timer to avoid sending multiple reloads for a single save event
      debounceTimer = Timer(const Duration(milliseconds: 500), () {
        print('\n[AutoReloader] File saved: ${event.path}. Triggering hot reload...');
        process.stdin.write('r');
      });
    }
  });
}
