origdata=/home/guyvanie/Downloads/GoodHealthCo-20160921/SBU_example_Surveydata_2014.csv

output/Diabetes_Status.csv: 03_build_model.R data/procsddata.RData
	R CMD BATCH 03_build_model.R

data/procsddata.RData: 02_read_data.R rawdata.csv
	R CMD BATCH 02_read_data.R

data/rawdata.csv: 01_setup.R $(origdata)
	R CMD BATCH 01_setup.R

clean:
	rm -f data/procsddata.RData data/rawdata.csv


	




