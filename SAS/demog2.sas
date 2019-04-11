**************************************************************************
Program Name : demog.sas
Study Name : NHOH-R-miniCHP
Author : Kato Kiroku
Date : 2019-03-28
SAS version : 9.4
**************************************************************************;


proc datasets library=work kill nolist; quit;

options mprint mlogic symbolgen minoperator;


*^^^^^^^^^^^^^^^^^^^^Current Working Directories^^^^^^^^^^^^^^^^^^^^;

*Find the current working directory;
%macro FIND_WD;

    %local _fullpath _path;
    %let _fullpath=;
    %let _path=;

    %if %length(%sysfunc(getoption(sysin)))=0 %then
      %let _fullpath=%sysget(sas_execfilepath);
    %else
      %let _fullpath=%sysfunc(getoption(sysin));

    %let _path=%substr(&_fullpath., 1, %length(&_fullpath.)
                       -%length(%scan(&_fullpath., -1, '\'))
                       -%length(%scan(&_fullpath., -2, '\')) -2);
    &_path.

%mend FIND_WD;

%let cwd=%FIND_WD;
%put &cwd.;

%inc "&cwd.\program\macro\libname.sas";

proc import out=perdata
    datafile="&raw.\R-mini CHP_ê∂îNåéì˙ ê´ï .xlsx"
    dbms=xlsx replace;
    datarow=3;
run;

data perdata;
    set perdata;
    if b=6 then delete;
run;

data dm;
    set libads.ptdata;
    if SUBJID=6 then delete;
run;


%macro COUNT (name, var, title);

    %if "&name"="Age" %then %do;
      proc freq data=z_age_sex noprint;
          tables &var / out=&name;
      run;
    %end;

    %if not(&name in (Age)) %then %do;
      proc freq data=z_others noprint;
          tables &var / out=&name;
      run;
    %end;

    data &name;
        set &name;
        c=strip(input(count, $12.));
        p=strip(put(round(percent, 0.1), 8.1));
        drop count percent;
        rename c=count p=percent;
    run;

    data &name._frame;
        format characteristics grade $24. count percent $12.;
        characteristics=' ';
        grade=' ';
        count=' ';
        percent=' ';
        output;
    run;

    proc sort data=&name; by &var; run;

    data &name._2;
        merge &name._frame &name;
        grade=compress(&var.);
        if _N_=1 then characteristics="&title.";
        drop &var;
    run;

%mend COUNT;


    
*Age;
data age_perdata;
    set perdata;
    format c YYMMDD10.;
    keep b c f;
    rename b=SUBJID c=borndate;
run;
data age_dm;
    set dm;
    id=input(SUBJID, best12.);
    keep id reg_day;
    rename id=SUBJID;
run;
data age_sex;
    merge age_perdata age_dm;
    by SUBJID;
    if SUBJID=6 then delete;
    reg_age=intck('YEAR', borndate, reg_day);
    if (month(reg_day)<month(borndate)) then reg_age=reg_age-1;
    else if (month(reg_day)=month(borndate))
              and day(reg_day)<day(borndate) then reg_age=reg_age-1;
run;
data z_age_sex;
    length id $4;
    set age_sex;
    if reg_age<=84 then agec='=<84';
    else if reg_age>84 then agec='84<';
    id=compress(put(subjid, best12.));
    keep id agec;
    rename id=subjid;
run;
proc sort data=z_age_sex; by subjid; run;
%COUNT (Age, agec, Age);

*PS; *Stage;
data z_others;
    format subjid psc stagec;
    set dm;
    format ps stagec $8.;
    if in_qsorres_ps in (5, 1) then psc='=<1';
    else if in_qsorres_ps in (2, 3) then psc='=>2';
    if in_patholo_ctg in (1, 2, 5, 6) then stagec='=<II';
    else if in_patholo_ctg in (3, 4, 7) then stagec='=>III';
    keep subjid psc stagec;
run;
proc sort data=z_others; by subjid; run;
%COUNT (PS, psc, PS);
%COUNT (Stage, stagec, Stage);


data demog2;
    set age_2 ps_2 stage_2;
run;

proc export data=demog2
    outfile="&out.\SAS\demog2.csv"
    dbms=csv replace;
run;
