**************************************************************************
Program Name : orr.sas
Study Name : NHOH-R-miniCHP
Author : Kato Kiroku
Date : 2019-02-14
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
        if RSORRES_best in (1, 2, 3) then c=1;
        else c=0;
        keep RSORRES_best c;
    run;

    proc freq data=ptdata noprint;
        tables c / out=ptdata_2;
    run;

    ods table binomial=CI_Values;
      proc freq data=ptdata;
          tables c / binomial(level='1');
          exact binomial;
      run;

    data CI_Values_2;
        set CI_Values;
        if Name1 in ('XL_BIN', 'XU_BIN') then output;
    run;

    proc transpose data=CI_Values_2 out=CI_Values_3;
        var cValue1;
    run;

    data CI_Values_4;
        set CI_Values_3;
        keep col1 col2;
        rename col1=lowercl col2=uppercl;
    run;

    data ptdata_3;
        set ptdata_2;
        percent=round(percent, 0.1);
        if c=1 then output;
        keep count percent;
    run;

    data orr;
        format title number $30.;
        merge ptdata_3 CI_Values_4;
        title='ORR';
        number="�ΏۏǗᐔ &_TN_";
    run;

    proc export data=orr
        outfile="&out.\SAS\orr.csv"
        dbms=csv replace;
    run;

%mend COUNT;

%COUNT;
