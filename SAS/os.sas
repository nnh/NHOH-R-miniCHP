**************************************************************************
Program Name : os.sas
Study Name : NHOH-R-miniCHP
Author : Kato Kiroku
Date : 2019-02-15
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

    data ptdata;
        set libads.ptdata;
        if subjid='6' then delete;
        if subjid='34' then delete;
        keep SUBJID fs1_ECRFTDTC dd_flg DDDTC surv_dy;
    run;

    data ptdata_2;
        set ptdata;
        if dd_flg=1 then do;
          day=DDDTC-fs1_ECRFTDTC;
          censor=0;
        end;
        if dd_flg NE 1 then do;
          day=surv_dy-fs1_ECRFTDTC;
          censor=1;
        end;
        years=round((day/365), 0.001);
        keep censor years;
    run;

    ods graphics on;
    ods rtf file="&out.\SAS\os.rtf";
    ods noptitle;
    ods select survivalplot;
      proc lifetest data=ptdata_2 stderr outsurv=os alpha=0.1 plot=survival;
          time years*censor(1);
      run;
    ods rtf close;
    ods graphics off;

    proc export data=os
        outfile="&out.\SAS\os.csv"
        dbms=csv replace;
    run;

%mend COUNT;


%COUNT;
