import streamlit as st
import pandas as pd
import datetime
import time
import os

# Initialize session state
if "recording" not in st.session_state:
    st.session_state["recording"] = False
if "state" not in st.session_state:
    st.session_state["state"] = 0  # Default to "Leave"
if "data" not in st.session_state:
    st.session_state["data"] = []

# App title
st.title("Time Series State Recorder")

# Display current date and time
current_time = datetime.datetime.now()
st.write(f"**Current DATE.TIME:** {current_time.strftime('%Y-%m-%d %H:%M:%S')}")

# Buttons for state change
col1, col2 = st.columns(2)

with col1:
    if st.button("Here!"):
        st.session_state["state"] = 1
        st.success("State set to 'Here!' (1)")

with col2:
    if st.button("Leave!"):
        st.session_state["state"] = 0
        st.warning("State set to 'Leave!' (0)")

# Start/Stop recording
if not st.session_state["recording"]:
    if st.button("Start!"):
        st.session_state["recording"] = True
        st.success("Recording started! Check the CSV for output.")
else:
    if st.button("Stop!"):
        st.session_state["recording"] = False
        st.warning("Recording stopped.")

# Save to CSV
output_file = "time_series_state.csv"

if st.session_state["recording"]:
    with st.spinner("Recording..."):
        while st.session_state["recording"]:
            # Capture current time and state
            current_time = datetime.datetime.now()
            st.session_state["data"].append({
                "DATE.TIME": current_time.strftime('%Y-%m-%d %H:%M:%S'),
                "State": st.session_state["state"]
            })

            # Save data to CSV
            pd.DataFrame(st.session_state["data"]).to_csv(output_file, index=False)

            # Display current state
            st.write(f"**Recording:** {current_time.strftime('%Y-%m-%d %H:%M:%S')} - State: {st.session_state['state']}")

            # Wait for 1 second
            time.sleep(1)

# Show success message
if os.path.exists(output_file):
    st.success(f"Data saved to {output_file}.")
