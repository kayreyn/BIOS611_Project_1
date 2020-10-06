.PHONY: clean

clean:
	rm -f assets/*.png
	rm -f figures/*.png
	rm -f figures/*.pdf
	rm -f derived_data/*.txt
	rm -f bin

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

figures/log.reg.table.png:\
	log_regression.R
	derived_data/pure_heart.txt
		Rscript log_regression.R

assets/cont_var_distributions.png: figures/cont_var_distributions.png
	cp figures/cont_var_distributions.png assets/cont_var_distributions.png

assets/disc_var_distributions.png: figures/disc_var_distributions.png
	cp figures/disc_var_distributions.png assets/disc_var_distributions.png

assets/log.reg.table.png: figures/log.reg.table.png 
	cp figures/log.reg.table.png assets/log.reg.table.png