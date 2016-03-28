/* small example */
libname example '/folders/myfolders';

/* proc import datafile='/folders/myfolders/table.csv'
DBMS=csv
out=example;
run; */

data examplenew;
	infile '/folders/myfolders/table.csv' dlm=',' firstobs=2; 
	/* firstobs=2 so that the line of column names is skipped*/
	input Date :yymmdd10. Open High Low Close Volume Adj_Close;
	format Date ddmmyy10.;
run;

proc contents data=examplenew;
run;

proc print data=examplenew label;
run;

proc means data=examplenew;
	var Open High Low Close Volume Adj_Close;
run;
