**************************************************************************
Program Name : sae_report.sas
Study Name : NHOH-R-miniCHP
Author : Kato Kiroku
Date : 2019-02-13
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


%macro COUNT;

    data _NULL_;
        set libads.ptdata end=last;
        if subjid='6' then delete;
        retain cnt 0;
        cnt+1;
        if last then call symputx("_TN_", cnt);
    run;

    %put &_TN_;

    data sae_report;
        set libads.sae_report;
        if subjid='6' then delete;
    run;

    proc sort data=sae_report; by AETERM_trm; run;

    proc freq data=sae_report noprint;
        tables AETERM_trm / out=sae_report_g;
    run;


    data sae_report_list;
        format number $30.;
        set sae_report_g;
        percent=(count/&_TN_)*100;
        percent=round(percent, 0.1);
        if _N_=1 then number="�ΏۏǗᐔ &_TN_";
    run;

    proc export data=sae_report_list
        outfile="&out.\SAS\sae_report.csv"
        dbms=csv replace;
    run;

%mend COUNT;

%COUNT;



data sae_sterben;
    set libads.ptdata;
    if subjid='6' then delete;
    if dd_flg='1';
    keep subjid dd_flg DDDTC DDORRES;
run;

proc freq data=sae_sterben noprint;
    tables dd_flg*DDORRES / out=sae_sterben_2;
run;

    proc summary data=sae_sterben_2;
        var count percent;
        output out=sae_sterben_2_total sum=;
    run;

    data sae_sterben_2_total;
        set sae_sterben_2_total;
        category='���v';
        keep Item Category Count Percent;
    run;

    data sae_sterben_3;
        set sae_sterben_2 sae_sterben_2_total;
    run;
