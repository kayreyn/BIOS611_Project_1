.PHONY: clean
SHELL: /bin/bash

Final_Report.pdf:\
 Final_Report.Rmd\
 figures/cont_var_distributions.png\
 figures/disc_var_distributions.png\
 derived_data/regression_output.txt\
 figures/ROC_Curve.png\
 figures/Threshold_Classification.png
	Rscript -e "rmarkdown::render('Final_Report.Rmd', output_format = 'pdf_document')"

clean:
	rm -f assets/*.png
	rm -f figures/*.png
	rm -f figures/*.pdf
	rm -f derived_data/*.txt
	rm -f *.pdf

derived_data/pure_heart.txt:\
 clean_data.R\
 source_data/cleveland.txt
	Rscript clean_data.R

figures/cont_var_distributions.png:\
 Make_Prelim_Figs.R\
 derived_data/pure_heart.txt
	Rscript Make_Prelim_Figs.R

figures/disc_var_distributions.png:\
 Make_Prelim_Figs.R\
 derived_data/pure_heart.txt
	Rscript Make_Prelim_Figs.R

derived_data/regression_output.txt:\
	log_regression.R\
	derived_data/pure_heart.txt
		Rscript log_regression.R

figures/Threshold_Classification.png:\
	log_regression.R
	derived_data/pure_heart.txt
		Rscript log_regression.R
		
figures/ROC_Curve.png:\
	log_regression.R
	derived_data/pure_heart.txt
		Rscript log_regression.R		

assets/cont_var_distributions.png: figures/cont_var_distributions.png
	cp figures/cont_var_distributions.png assets/cont_var_distributions.png

assets/disc_var_distributions.png: figures/disc_var_distributions.png
	cp figures/disc_var_distributions.png assets/disc_var_distributions.png
	
assets/Threshold_Classification.png: figures/Threshold_Classification.png
	cp figures/Threshold_Classification.png assets/Threshold_Classification.png
	
assets/ROC_Curve.png: figures/ROC_Curve.png
	cp figures/ROC_Curve.png assets/ROC_Curve.png