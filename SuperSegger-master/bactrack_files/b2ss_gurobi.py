from bactrack.widget import get_hierarchies_from_masks_folder
from bactrack.tracking import OverlapWeight, IOUWeight, DistanceWeight
from bactrack.tracking import MIPSolver, ScipySolver
from bactrack import io

import pandas as pd
import os

# get hierarchies from masks
mask_dir = "/home/tlo/Documents/Data/bactrack_test3/xy0/masks"
hier_arr = get_hierarchies_from_masks_folder(mask_dir)

# set matrix weights
w =  OverlapWeight(hier_arr)

# minimize matrix using gurobi solver
solver = MIPSolver(w.weight_matrix, hier_arr)

n, e = solver.solve()

# load masks, edge, node outputs
m, e = io.format_output(hier_arr, n, e,overwrite_mask = False)
n = io.hiers_to_df(hier_arr)

# merge edge and node dataframes
merged_df = pd.merge(e, n.add_suffix('_source'), left_on='Source Index', right_on='index_source', how='left')
merged_df = pd.merge(merged_df, n.add_suffix('_target'), left_on='Target Index', right_on='index_target', how='left')

# export links to csv
xydir = os.path.abspath(os.path.join(mask_dir, os.pardir)) 
bactrackdir = os.path.join(xydir, "bactrackfiles")
os.makedirs(bactrackdir, exist_ok=True) 

merged_df.to_csv(os.path.join(bactrackdir, "mergedlinks.csv")) 

selected_df = merged_df[['frame_source','label_source', 'label_target','area_source','area_target']]
selected_df.to_csv(os.path.join(bactrackdir, "superseggerlinks.csv")) 