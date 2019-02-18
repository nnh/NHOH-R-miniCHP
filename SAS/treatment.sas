**************************************************************************
Program Name : treatment.sas
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

%macro FMTNUM2CHAR (variable);
    %let dsid=%sysfunc(open(&SYSLAST.));
    %let varnum=%sysfunc(varnum(&dsid,&variable));
    %let fmt=%sysfunc(varfmt(&dsid,&varnum));
    %let dsid=%sysfunc(close(&dsid));
    &fmt
%mend FMTNUM2CHAR;

data dm;
    set libads.ptdata;
    if SUBJID='6' then delete;
    keep subjid fs1_ec_chp_stdtc fs2_ec_chp_stdtc fs3_ec_chp_stdtc fs4_ec_chp_stdtc fs5_ec_chp_stdtc fs6_ec_chp_stdtc;
run;

%macro COUNT_1;

    data start;
        set dm;
        %do i=1 %to 6;
          if fs&i._ec_chp_stdtc=. then a_&i=0;
          else a_&i=1;
          drop fs&i._ec_chp_stdtc;
        %end;
    run;

    data start_frame;
        format title grade $30. count percent best12.;
        %do i=1 %to 6;
          title=' ';
          grade="&i";
          count=0;
          percent=0;
          output;
        %end;
    run;

    %do i=1 %to 6;
      proc freq data=start noprint;
          table a_&i / out=start_a_&i;
      run;
      data start_a_&i;
          format grade $30.;
          set start_a_&i;
          grade="&i";
          if a_&i=0 then delete;
          drop a_&i;
      run;
    %end;

    data start_total;
        merge start_frame start_a_1 start_a_2 start_a_3 start_a_4 start_a_5 start_a_6;
        by grade;
        percent=round(percent, 0.1);
        if _N_=1 then title="R-mini CHP治療コース数";
    run;

    proc export data=start_total
        outfile="&out.\SAS\treatment_start.csv"
        dbms=csv replace;
    run;

%mend COUNT_1;

%COUNT_1;


%macro COUNT_2;

    data cancel;
        set libads.ptdata;
        if SUBJID='6' then delete;
        keep subjid dsdtc dsterm ds_epoch_dy ds_epoch;
        if ds_epoch=. then delete;
    run;

    data cancel_frame;
        format title grade $30. ds_epoch FMT_27_F25. count percent best12.;
        do ds_epoch=1 to 7;
          title=' ';
          grade=' ';
          count=0;
          percent=0;
          output;
        end;
    run;

    proc freq data=cancel noprint;
        tables ds_epoch / out=cancel_1;
    run;

    data cancel_total;
        merge cancel_frame cancel_1;
        by ds_epoch;
        grade=put(ds_epoch, %FMTNUM2CHAR(ds_epoch));
        percent=round(percent, 0.1);
        if _N_=1 then title="R-mini CHP中止したコース数";
        keep title grade count percent;
    run;

    proc export data=cancel_total
        outfile="&out.\SAS\treatment_cancel.csv"
        dbms=csv replace;
    run;

%mend COUNT_2;

%COUNT_2;


proc freq data=cancel noprint;
    tables DSTERM / out=cancel_rsn;
run;

data treatment_cancel_rsn;
    set cancel_rsn;
    percent=round(percent, 0.1);
run;

proc export data=treatment_cancel_rsn
    outfile="&out.\SAS\treatment_cancel_rsn.csv"
    dbms=csv replace;
run;
