# StateTracker

## Presence and Absence Timestamp Recorder

This Streamlit application allows users to record their presence (`Here!`) or absence (`Leave!`) along with timestamps, saving the data to a CSV file. It is specifically designed for scenarios where other data is being recorded, and the user needs to timestamp their state during the recording process. StateTracker can be used to label other recorded data for machine learning purpose.

---

## Features

- **Live Time Display**: Shows the current date and time in real-time.
- **State Buttons**: 
  - `Here!` sets the state to `1` (presence).
  - `Leave!` sets the state to `0` (absence).
- **Start and Stop Recording**:
  - Start recording timestamps and states at one-second intervals by clicking `Start!`.
  - Stop recording at any time by clicking `Stop!`.
- **CSV Output**: Saves the data to a CSV file (`time_series_state.csv`) with two columns:
  1. `DATE.TIME`: The timestamp of the recording.
  2. `State`: The state (1 for presence, 0 for absence).

---

## Installation

1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Install Required Dependencies**:
   Make sure you have Python 3.8+ and `pip` installed. Then, install the required Python packages:
   ```bash
   pip install streamlit pandas
   ```

---

## Usage

1. **Run the Application**:
   Start the Streamlit app from the terminal:
   ```bash
   streamlit run app.py
   ```

2. **Interact with the App**:
   - The app will display the current date and time.
   - Use the `Here!` and `Leave!` buttons to set your state.
   - Click `Start!` to begin recording your state and timestamp every second.
   - Click `Stop!` to stop the recording.

3. **View the Data**:
   - The recorded data will be saved to a file named `time_series_state.csv` in the same directory as the app.

4. **CSV File Format**:
   - The CSV file contains two columns:
     - `DATE.TIME`: Timestamps of each recording.
     - `State`: The state at the recorded timestamp (1 for presence, 0 for absence).

---

## Example

**CSV Output**:
```csv
DATE.TIME,State
2024-12-03 10:00:00,1
2024-12-03 10:00:01,1
2024-12-03 10:00:02,0
...
```

---

## Applications

This app is ideal for:
- Timestamping presence and absence while recording environmental or light spectrum data.
- Behavioral and activity studies requiring manual state input.

---

## Requirements

- **Python**: Version 3.8 or later.
- **Streamlit**: Version 1.0 or later.
- **Pandas**: Version 1.3 or later.

---

## Customization

You can modify the app to:
- Adjust the recording frequency.
- Change the output CSV file name or directory.
- Add additional fields to the CSV (e.g., location, comments).

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## Acknowledgments

This app was created to support projects involving light spectrum recording, where the presence and absence of the user play a crucial role in data annotation.

---

**Author**: Ali Rahjouei, Dr. rer. nat.   
**Contact**: ali.rahjouei@gmail.com
