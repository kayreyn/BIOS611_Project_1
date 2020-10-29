.PHONY: clean
SHELL: /bin/bash

Final_Report.pdf:\
 Final_Report.Rmd\
 figures/final_disc_var.png\
 figures/final_cont_var.png\
 derived_data/regression_output.txt\
 figures/ROC_Curve.png\
 figures/Threshold_Classification.png
	Rscript -e "rmarkdown::render('Final_Report.Rmd', output_format = 'pdf_document')"

HW_4.pdf:\
 HW4.Rmd\
 source_data/gen_height_weight.txt
	Rscript -e "rmarkdown::render('HW4.Rmd', output_format = 'pdf_document')"

HW_5.pdf:\
 Homework5.Rmd\
 figures/H5_PlotNine.png\
 source_data/HW5_HeightWeight.txt\
 source_data/HW5_Heros.txt\
 derived_data/Hw5_python.txt
	Rscript -e "rmarkdown::render('Homework5.Rmd', output_format = 'pdf_document')"

clean:
	rm -f figures/*.png
	rm -f figures/*.pdf
	rm -f derived_data/*.txt
	rm -f *.pdf
	rm -f *.py
	rm -f *.html
	
derived_data/pure_heart.txt:\
 clean_data.R\
 source_data/cleveland.txt
	Rscript clean_data.R

figures/final_cont_var.png\
figures/disc_var_distributions.png\
figures/final_disc_var.png:\
 Make_Prelim_Figs.R\
 derived_data/pure_heart.txt
	Rscript Make_Prelim_Figs.R
	
derived_data/regression_output.txt\
figures/Threshold_Classification.png\
figures/ROC_Curve.png:\
 log_regression.R\
 derived_data/pure_heart.txt
	
assets/final_cont_var.png: figures/final_cont_var.png
	cp figures/final_cont_var.png assets/final_cont_var.png

assets/disc_var_distributions.png: figures/disc_var_distributions.png
	cp figures/disc_var_distributions.png assets/disc_var_distributions.png

derived_data/hw5_python.txt\
figures/H5_PlotNine.png:\
 HW5-Python.ipynb\
 source_data/HW5_Heros.txt
	jupyter nbconvert --to=python HW5-Python.ipynb
	python3 HW5-Python.py 