libname Amu "C:\Users\serge\Desktop\Cours\Master_1\Applied multivariate";

PROC IMPORT
DATAFILE='C:\Users\serge\Desktop\Cours\Master_1\Applied
multivariate\bdd.xls'
DBMS=xls
OUT= Amu.base
REPLACE;
run;

/* PCA procedure: producing an rtf file*/
ods rtf file="C:\Users\serge\Desktop\Cours\Master_1\Applied
multivariate\PCASTATES.rtf";
proc princomp data=amu.base plots(ncomp=3)=all out=amu.comp prefix=C;
var Age Income Medicare Labor Expenses Hospitals Beds Population; /*Specify the variables involved in PCA*/
id code; /*The names identifying observations*/
run;

/* ratio of norms */
data norms (keep= code C1-C3 rap1-rap3 rapp1 rapp2 rapp3);
set comp;
norm=sqrt(C1**2+C2**2+C3**2+C4**2+C5**2+C6**2+C7**2+C8**2);

norm1=sqrt(C1**2);
rap1=norm1/norm;
norm2=sqrt(C2**2);
rap2=norm2/norm;
norm3=sqrt(C3**2);
rap3=norm3/norm;

normp12=sqrt(C1**2+C2**2);
rapp1=normp12/norm;
normp13=sqrt(C1**2+C3**2);
rapp2=normp12/norm;
normp23=sqrt(C2**2+C3**2);
rapp3=normp23/norm;
run;

/*Print the norms to see how well obs are represented*/
proc print data=norms;
run;
ods rtf close;

ods rtf file="C:\Users\serge\Desktop\Cours\Master_1\Applied
multivariate\USCL.rtf";
/*k-means clustering*/
proc fastclus data=amu.comp out=resat
maxclusters=5 /*number of clusters choosen */
replace=part /*initial seeds choice*/
maxiter =20 /*maximum number of iteratioons*/
drift /* centers recalculated after each reallocation of one observation*/
list /*gives the cluster variables that gives the cluster to which each observation belongs to*/
distance /* gives the distance between the centers (means) of the final groups*/;
var C1 C2;
id Code;
run;

/*Plot the cluster with Component 1 and 2*/
proc sgplot data=resat;
scatter x=C1 y=C2 /datalabel=cluster;
run;

/*AHC method*/
proc cluster data=amu.comp std method = ward noeigen out=rescah;
var C1 C2;
id Code;
run;
proc sgplot data=rescah;
scatter x=_SPRSQ_ y=_NCL_;
run;

proc tree data=rescah nclusters=5 out=amu.cluster;
copy C1 C2;
run;

proc means data=amu.cluster N mean std cv;
var C1 C2;
by cluster;
run;
ods rtf close;
