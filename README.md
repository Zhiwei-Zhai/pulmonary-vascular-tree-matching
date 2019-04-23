# pulmonary vessel tree matching

The source code works with pulmonary vascular tree matching, including point set registration methods of CPD [1], GLTP [2] and GLTPg [3]. The pre-processing step of vessel tree extraction and editing is provided, more details about the soure code could be find in the MICCAI paper of [3].

A data set of 10 synthetic trees is included in './inputs/VesselNode_deformed/'.

How to run?
```
1. run "S1_Run_Synthetic_Tree_nodeOnly.m" to play with synthetic trees.
```
 
<div align="center">
    <img src="https://github.com/chushan89/pulmonary-vascular-tree-matching/blob/master/inputs/Comparing_CPD_GLPT_GLPTg.png" width="80%" height="50%"/>
    <br>  
    <em align="center">Fig 1: A 3D visualization of vascular tree matching for the matching between T5 and T1, CPD, GLTP and our method.</em>  
</div>



If you use the software, you should reference the following paper:
```
@inproceedings{zhai2018pulmonary,
  title={Pulmonary vessel tree matching for quantifying changes in vascular morphology},  
  author={Zhai, Zhiwei and Staring, Marius and Ota, Hideki and Stoel, Berend C},  
  booktitle={International Conference on Medical Image Computing and Computer-Assisted Intervention},  
  pages={517--524},  
  year={2018},  
  organization={Springer}
}
```

If the methods used for comparison, please reference the corresponding literatures:

[1] Myronenko, Andriy, and Xubo Song. "Point set registration: Coherent point drift." IEEE transactions on pattern analysis and machine intelligence 32.12 (2010): 2262-2275.

[2] Ge, Song, Guoliang Fan, and Meng Ding. "Non-rigid point set registration with global-local topology preservation." Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition Workshops. 2014.

[3] Zhai, Zhiwei, et al. "Pulmonary vessel tree matching for quantifying changes in vascular morphology." International Conference on Medical Image Computing and Computer-Assisted Intervention. Springer, Cham, 2018.
