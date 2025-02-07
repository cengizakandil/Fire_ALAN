This repository contains the code for analysis and the accompanying figures in the manscuript of "Increased Arctic fire occurrence related to human activity calls for improved management". 

### Data

* The consistent and corrected nighttime light (CCNL) dataset available as GeoTIFF format at https://zenodo.org/record/6644980
* We used processed (cropped, outliers removed) annual ALAN data from https://github.com/PlekhanovaElena/ALAN_Arctic
* Terra climate data of precipitation and VPD is available at Catalog http://thredds.northwestknowledge.net:8080/thredds/catalog/TERRACLIMATE_ALL/data/catalog.html
* Land Surface Temperature data of MODIS 11C3 can be downloaded from https://ladsweb.modaps.eosdis.nasa.gov/archive/allData/61/MOD11C3/
* Fire data of MODIS Fire_cci v5.1 can be downloaded from https://data.ceda.ac.uk/neodc/esacci/fire/data/burned_area/MODIS/pixel/v5.1/
* Additional data for the current analysis can be downloaded from https://zenodo.org/uploads/14831684

### Code

**Data Preparation folder** includes the r codes for creating the cumulative ALAN datasets for each year and creating the centroids of the fire scars. 
Cumulative ALAN has digital number (DN) values and Masked ALAN is binary: 1 for the lit area and 0 for unlit area. They are available at the Zenodo [depository](https://zenodo.org/uploads/14831684).

**Analysis folder** includes the example year of 2012 only. 
Due to computational requirements, we needed to calculate each year separately so the example code needed to be adjusted for each year, such as number of fires that year, cumulative ALAN mask, and separate climate variables of each year. Fire_distance file includes the code for calculation of distance of each fire centroid to the nearest ALAN. 
Climate-var file contains the code for calculating the climate variables of each fire scar. Control_distance file contains the code for sampling 1000 closest points in the Arctic with similar climate variables to fire scar, then randomly choosing 3 control points and finding their disatnces to the nearest lit area.
The data table with all the fire centroids, control points, and the distances to the nearest lit area are available at final data table.

**Figure folder** includes the code to create the figure in the manuscript based on the above data table. 





Contact
Code development and maintenance: Cengiz Akandil (cengiz.akandil@ieu.uzh.ch)


Citation
When citing elements in this repository, please cite as:

Akandil, C., Heim, J. R., Plekhanova, E., Rietze, N., Roman, M.O., Wang, Z., Furrer, R., Schaepman-Strub, G. (in prep.). Increased Arctic fire occurrence related to human activity calls for improved management. 


License
The scripts in this repository (*.R files) are licensed under the MIT license (see [license text](https://github.com/nrietze/SiberiaFires/blob/main/LICENSE)).<br>

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />The remaining content in this repo is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.


