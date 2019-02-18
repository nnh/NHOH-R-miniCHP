**************************************************************************
Program Name : pfs.sas
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
        keep SUBJID ds_epoch fs1_ECRFTDTC rec1_yn rec1_dy prog_yn rprog_dy dd_flg DDDTC surv_flg surv_dy DSTERM fs1_ECENDTC fs4_ECENDTC;
    run;

    data ptdata_2;
        set ptdata;
        if rec1_yn=1 and prog_yn=1 then do;
          if rec1_dy<=rprog_dy then earliest=rec1_dy;
          if rprog_dy<=rec1_dy then earliest=rprog_dy;
          censor=0;
        end;
        if rec1_yn=1 and prog_yn=2 then do;
          earliest=rec1_dy;
          censor=0;
        end;
        if rec1_yn=2 and prog_yn=1 then do;
          earliest=rprog_dy;
          censor=0;
        end;
        if rec1_yn=2 and prog_yn=2 and dd_flg='1' then do;
          earliest=DDDTC;
          censor=0;
        end;
        if rec1_yn=2 and prog_yn=2 and dd_flg=' ' and surv_dy NE . then do;
          earliest=surv_dy;
          censor=1;
        end;
        if DSTERM=16 and ds_epoch=1 then do;
          if earliest<=fs1_ECENDTC then earliest=earliest;
          else if fs1_ECENDTC<=earliest then earliest=fs1_ECENDTC;
        end;
        if DSTERM=16 and ds_epoch=4 then do;
          if earliest<=fs4_ECENDTC then earliest=earliest;
          else if fs4_ECENDTC<=earliest then earliest=fs4_ECENDTC;
        end;
        keep fs1_ECRFTDTC earliest censor;
    run;

    data ptdata_3;
        set ptdata_2;
        day=earliest-fs1_ECRFTDTC;
        years=round((day/365), 0.001);
        keep censor years;
    run;

    ods graphics on;
    ods rtf file="&out.\SAS\pfs.rtf";
    ods noptitle;
    ods select survivalplot;
      proc lifetest data=ptdata_3 stderr outsurv=pfs alpha=0.1 plot=survival;
          time years*censor(1);
      run;
    ods rtf close;
    ods graphics off;


    proc export data=pfs
        outfile="&out.\SAS\pfs.csv"
        dbms=csv replace;
    run;

%mend COUNT;

%COUNT;

