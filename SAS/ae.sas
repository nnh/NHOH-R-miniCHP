**************************************************************************
Program Name : ae.sas
Study Name : NHOH-R-miniCHP
Author : Kato Kiroku
Date : 2019-02-18
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


%macro COUNT (course, no);

    %if &course.=all %then %do;
      data _NULL_;
          set libads.ptdata end=last;
          if subjid='6' then delete;
          retain cnt 0;
          cnt+1;
          if last then call symputx("_TN_", cnt);
      run;
    %end;

    %if &course. NE all %then %do;
      data ptdata_&no.;
          set libads.ptdata;
          if subjid='6' then delete;
          if ds_epoch<&no and ds_epoch NE . then delete;
      run;

      data _NULL_;
          set ptdata_&no. end=last;
          retain cnt 0;
          cnt+1;
          if last then call symputx("_TN_", cnt);
      run;
    %end;

    data ae;
        set libads.ae libads.sae_report;
        if subjid='6' then delete;
        where ae_epoch in (&no);
    run;

    proc sort data=ae;
        by SUBJID AETERM_trm descending AETERM_grd descending AESTDTC;
    run;

    proc sort data=ae nodupkey out=noduplicates;
        by SUBJID AETERM_trm;
    run;

    proc sort data=noduplicates; by AETERM_grd; run;

    proc freq data=noduplicates noprint;
        tables AETERM_trm / out=ae_g;
        by AETERM_grd;
    run;

    proc freq data=ae noprint;
        tables AETERM_trm / out=ae_total;
    run;

    data ae_g3 ae_g4 ae_g5 ae_g345;
        set ae_g;
        if AETERM_grd=3 then output ae_g3;
        else if AETERM_grd=4 then output ae_g4;
        else if AETERM_grd=5 then output ae_g5;
        if AETERM_grd>=3 then output ae_g345;
    run;

    data ae_g3_1;
        set ae_g3;
        percent=round((count/&_TN_.)*100, 0.01);
        keep AETERM_trm count percent;
        rename count=g3_count percent=g3_percent;
    run;

    data ae_g4_1;
        set ae_g4;
        percent=round((count/&_TN_.)*100, 0.01);
        keep AETERM_trm count percent;
        rename count=g4_count percent=g4_percent;
    run;

    data ae_g5_1;
        set ae_g5;
        percent=round((count/&_TN_.)*100, 0.01);
        keep AETERM_trm count percent;
        rename count=g5_count percent=g5_percent;
    run;

    data ae_g345_1;
        set ae_g345;
        percent=round((count/&_TN_.)*100, 0.01);
        keep AETERM_trm count percent;
        rename count=g345_count percent=g345_percent;
    run;

    proc sort data=ae_g3_1; by AETERM_trm; run;
    proc sort data=ae_g4_1; by AETERM_trm; run;
    proc sort data=ae_g5_1; by AETERM_trm; run;
    proc sort data=ae_g345_1; by AETERM_trm; run;

    data ae_&course;
        format number $30.;
        merge ae_g3_1 ae_g4_1 ae_g5_1 ae_g345_1;
        by AETERM_trm;
        if g3_count=. then g3_count=0;
        if g3_percent=. then g3_percent=0;
        if g4_count=. then g4_count=0;
        if g4_percent=. then g4_percent=0;
        if g5_count=. then g5_count=0;
        if g5_percent=. then g5_percent=0;
        if g345_count=. then g345_count=0;
        if g345_percent=. then g345_percent=0;
        if _N_=1 then number="�ΏۏǗᐔ &_TN_";
    run;

    proc export data=ae_&course
        outfile="&out.\SAS\ae_&course..csv"
        dbms=csv replace;
    run;

%mend COUNT;

%COUNT (all, 1 2 3 4 5 6 7);
%COUNT (course1, 1);
%COUNT (course2, 2);
%COUNT (course3, 3);
%COUNT (course4, 4);
%COUNT (course5, 5);
%COUNT (course6, 6);
