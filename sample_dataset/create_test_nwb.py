import spikeinterface as si
from pathlib import Path

from pynwb import NWBHDF5IO
from pynwb.testing.mock.file import mock_NWBFile, mock_Subject
from neuroconv.tools.spikeinterface import add_recording_to_nwbfile

this_folder = Path(__file__).parent

duration = 180
num_channels = 32
num_units = 20
output_folder = this_folder / "nwb"
output_folder.mkdir(exist_ok=True)

recording, sorting = si.generate_ground_truth_recording(
    num_channels=num_channels,
    num_units=num_units,
    durations=[duration],
)

nwbfile = mock_NWBFile()
nwbfile.subject = mock_Subject()
add_recording_to_nwbfile(recording, nwbfile=nwbfile)

with NWBHDF5IO(output_folder / "sample.nwb", mode="w") as io:
    io.write(nwbfile)