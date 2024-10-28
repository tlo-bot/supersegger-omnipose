# Segmentation Options 

 When running the Omnipose command in conda, the following default Omnipose options can be modified depending on the desired usage: "--cluster --mask_threshold 1 --flow_threshold 0 --diameter 30 --exclude_on_edges". 
 
--cluster: DBscan clustering, reduces oversegmentation of thin features [can remove option]
 
--mask_threshold: mask threshold [0 default, decrease to find more and larger masks]

--flow_threshold: flow error threshold [0.4 default, 0 to turn off]
 
--diameter: approximate diameter of cell in pixels (for rod-shape, this is the length of the short axis) [30 default, 0 to have omnipose estimate for each image]

--exclude_on_edges: discard masks which touch edges of image [can remove option]
 
 Mask and flow threshold numbers can be tested quickly with the [Omnipose GUI](https://omnipose.readthedocs.io/gui.html) (`python -m omnipose`). In addition, other Omnipose options can be added to possibly improve segmentation. 

 Optional commands to try:

 --use_gpu: utilize GPU, if conda environment is set up for GPU usage
 
 --affinity_seg: new affinity segmentation; likely helps for cells with self-contact
 
 --tile: tiles image and rescales per tile; likely helps for images of large size
 
##### Training Models: Other models can be used as well instead of the default "bact_phase_omni".

Fluorescence model: Replace the `bact_phase_omni` argument after `--pretrained_model` with `bact_fluor_omni`.

Custom model: Replace the `bact_phase_omni` argument after `--pretrained_model` with the path to the model.

##### Note that the options before "--omni" should not be changed when working with OmniSegger.
