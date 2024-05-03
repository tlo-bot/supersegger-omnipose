# Segmentation Options 

 When running the Omnipose command in conda, the following default Omnipose options can be modified depending on the desired usage: "--cluster --mask_threshold 1 --flow_threshold 0 --diameter 30". 
 
--cluster: DBscan clustering, reduces oversegmentation of thin features [can remove option]
 
--mask_threshold: mask threshold [0 default, decrease to find more and larger masks]

--flow_threshold: flow error threshold [0.4 default, 0 to turn off]
 
--diameter: approximate diameter of cell in pixels (for rod-shape, this is the length of the short axis) [30 default, 0 to have omnipose estimate for each image]
 
 Mask and flow threshold numbers can be tested quickly with the [Omnipose GUI](https://omnipose.readthedocs.io/gui.html) (`python -m omnipose`). In addition, other Omnipose options can be added to possibly improve segmentation. 
 
##### Training Models: Other models can be used as well instead of the default "bact_phase_omni".

##### Note that the options before "--omni" should not be changed when working with SuperSegger 2.
