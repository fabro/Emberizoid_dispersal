# Emberizoid_dispersal

This repository contains the necessary code and data to reproduce the analyses performed in Arango et al. "Hand-Wing Index as a surrogate for dispersal ability: the case of the Emberizoidea (Aves: Passeriformes) radiation" submitted to the Biological Journal of the Linnean Society. 

File description:

Data: This folder contains the data (or links to the data) from which we derived the data sets used in all downstream analyses (see next folders)

	-corrected_mcc.txt: This file is the Barker et al. (2015) MCC phylogenetic tree, with the tips modified to match the 2019 Emberizoidea taxonomy.

	-Emberizo maps: a text file with the link to species' shapefiles as obtained from the GDB provided by BirdLife International (2019).

	-emberizoidea_radiation: a table containing the taxonomy of the Emberizoids (as for 2019), including some notes regarding their distribution and English names
	
	-HWI_raw.csv: This file contains the Collection number of every measured specimen along with raw measurements of Wing length (WL) and secondary length (SL) in addition to the HWI calculation (100x((WL-SL/WL)). All data was collected between September-November, 2019.

Distance: This folder contains all the required files to calculate the geodesic migratory distance of Emberizoidea species, as well as the PGLS where HWI predicts migration distance

	-corrected_mcc.txt: This file is the Barker et al. (2015) MCC phylogenetic tree, with the tips modified to match the 2019 Emberizoidea taxonomy.

	-Emberizo maps: a text file with the link to species' shapefiles as obtained from the GDB provided by BirdLife International (2019).

	-hwi_data_sub.csv: This file contains the Emberizoidea species that had at least 3 measured specimens, formatted to match the phylogeny (sp), the average HWI per species (HWI), their migratory behavior	(migratory), and the area of distribution (area). The last two are calculated as specified in the study using QGIS.

	-hwi_distance_sub.csv: This file contains the migratory species used for this study (sp), and their average HWI, along with the calculated geodesic distances in km (distances_mid). Code is provided for duplicating these calculations
	
	-Distance_masterscript.R: This script contains the code to calculate the geodesic migratory distance of Emberizoidea species, as well as the PGLS where HWI predicts migration distance

PGLS: This folder contains all the required files to conduct a PGLS where area is predicted by HWI, as well as the calculations for phylogenetic signal and phylogenetic half-life by means of evolutionary model fitting.

	-corrected_mcc.txt: This file is the Barker et al. (2015) MCC phylogenetic tree, with the tips modified to match the 2019 Emberizoidea taxonomy.

	-hwi_data_sub.csv: This file contains the Emberizoidea species that had at least 3 measured specimens, formatted to match the phylogeny (sp), the average HWI per species (HWI), their migratory behavior	(migratory), and the area of distribution (area). The last two are calculated as specified in the study using QGIS.
	
	-PGLS-phylogenetic signal.R: This script contains the code to calculate the PGLS where area is predicted by HWI, along with the calculations for phylogenetic signal and phylogenetic half-life through the fit and comparison of evolutionary models.

	
Contact:
axlarango@gmail.com
fabricio.villalobos@gmail.com
		
