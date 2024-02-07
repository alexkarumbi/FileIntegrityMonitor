# File Integrity Monitor in PowerShell

This repository contains a PowerShell script that monitors file integrity in a directory in real-time. It calculates SHA512 hashes of files and stores them in a baseline file. The script detects and alerts on file creation, deletion, and content changes. It also handles file renaming and continuous monitoring of newly added files.

## Features
- **File Hashing**: Calculates SHA512 hashes of files and stores them in a baseline file.
- **File Creation Detection**: Detects and alerts when a new file is created in the directory.
- **File Deletion Detection**: Detects and alerts when a file is deleted from the directory.
- **File Change Detection**: Detects and alerts when a file's content is changed.
- **File Renaming Handling**: Handles file renaming by treating it as a file deletion and a file creation.
- **Continuous Monitoring**: Continuously monitors newly added files for any changes in content or deletion.

## Usage
1. Run the script in PowerShell.
2. When prompted, enter 'A' to collect a new baseline or 'B' to begin monitoring files with a saved baseline.

## Future Enhancements
- Add support for subdirectories.
- Improve performance for large directories.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


