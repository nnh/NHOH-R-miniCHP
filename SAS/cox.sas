**************************************************************************
Program Name : cox.sas
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

libname coxds "&cwd.\input\ads\SAS";

data cox;
    set coxds.coxds;
run;



%macro CATEGORICAL_V_pfs (var, char, ref);
    ods select ClassLevelInfo CensoredSummary ParameterEstimates;
    proc phreg data=cox;
        class &var (ref=&ref);
        model years_pfs*censor_pfs(1)=&var / rl;
        title "&char";
        footnote "&char";
    run;
    ods select all;
%mend CATEGORICAL_V_pfs;
%macro NUMERICAL_V_pfs (var, char);
    data cox_num;
        set cox;
        if missing(&var) then delete;
    run;
    ods select CensoredSummary ParameterEstimates;
    proc phreg data=cox_num;
        model years_pfs*censor_pfs(1)=&var / rl;
        title "&char";
        footnote "&char";
    run;
    ods select all;
%mend NUMERICAL_V_pfs;


%macro CATEGORICAL_V_os (var, char, ref);
    ods select ClassLevelInfo CensoredSummary ParameterEstimates;
    proc phreg data=cox;
        class &var (ref=&ref);
        model years_os*censor_os(1)=&var / rl;
        title "&char";
        footnote "&char";
    run;
    ods select all;
%mend CATEGORICAL_V_os;
%macro NUMERICAL_V_os (var, char);
    data cox_num;
        set cox;
        if missing(&var) then delete;
    run;
    ods select CensoredSummary ParameterEstimates;
    proc phreg data=cox_num;
        model years_os*censor_os(1)=&var / rl;
        title "&char";
        footnote "&char";
    run;
    ods select all;
%mend NUMERICAL_V_os;


%macro CATEGORICAL_V_dfs (var, char, ref);
    ods select ClassLevelInfo CensoredSummary ParameterEstimates;
    proc phreg data=cox;
        class &var (ref=&ref);
        model years_dfs*censor_dfs(1)=&var / rl;
        title "&char";
        footnote "&char";
    run;
    ods select all;
%mend CATEGORICAL_V_dfs;
%macro NUMERICAL_V_dfs (var, char);
    data cox_num;
        set cox;
        if missing(&var) then delete;
    run;
    ods select CensoredSummary ParameterEstimates;
    proc phreg data=cox_num;
        model years_dfs*censor_dfs(1)=&var / rl;
        title "&char";
        footnote "&char";
    run;
    ods select all;
%mend NUMERICAL_V_dfs;



ods graphics on;
ods pdf file="&out.\SAS\cox_pfs.pdf";
ods rtf file="&out.\SAS\cox_pfs.rtf";

%CATEGORICAL_V_pfs (agec, Age, '84<');
%CATEGORICAL_V_pfs (sex, Sex, '�j��');
%CATEGORICAL_V_pfs (ps, PS, '=<1');
%CATEGORICAL_V_pfs (stagec, Stage, '=<II');
%NUMERICAL_V_pfs (ipi, IPI);
%CATEGORICAL_V_pfs (marrow, Marrow involvement, '�A��');
%CATEGORICAL_V_pfs (bulky, Bulky disease, '�Ȃ�');
%CATEGORICAL_V_pfs (bulky_mass, Bulky mass, '�Ȃ�');
%CATEGORICAL_V_pfs (liver, ��_�a�ς̗L��, '�Ȃ�');
%CATEGORICAL_V_pfs (spleen, �B_�a�ς̗L��, '�Ȃ�');
%CATEGORICAL_V_pfs (kidney, �t_�a�ς̗L��, '�Ȃ�');
%CATEGORICAL_V_pfs (bsymptom, B symptoms, '�Ȃ�');
%CATEGORICAL_V_pfs (weight, Weight loss, 'FALSE');
%CATEGORICAL_V_pfs (nsweats, Night sweats, 'FALSE');
%CATEGORICAL_V_pfs (fever, Fever, 'FALSE');
%CATEGORICAL_V_pfs (ldh, LDH IU/L, '<250');
%NUMERICAL_V_pfs (b2mg, ��2MG(mg/L));
%NUMERICAL_V_pfs (sil2r, ����sIL-2R);

ods rtf close;
ods pdf close;
ods graphics off;


ods graphics on;
ods pdf file="&out.\SAS\cox_os.pdf";
ods rtf file="&out.\SAS\cox_os.rtf";

%CATEGORICAL_V_os (agec, Age, '84<');
%CATEGORICAL_V_os (sex, Sex, '�j��');
%CATEGORICAL_V_os (ps, PS, '=<1');
%CATEGORICAL_V_os (stagec, Stage, '=<II');
%NUMERICAL_V_os (ipi, IPI);
%CATEGORICAL_V_os (marrow, Marrow involvement, '�A��');
%CATEGORICAL_V_os (bulky, Bulky disease, '�Ȃ�');
%CATEGORICAL_V_os (bulky_mass, Bulky mass, '�Ȃ�');
%CATEGORICAL_V_os (liver, ��_�a�ς̗L��, '�Ȃ�');
%CATEGORICAL_V_os (spleen, �B_�a�ς̗L��, '�Ȃ�');
%CATEGORICAL_V_os (kidney, �t_�a�ς̗L��, '�Ȃ�');
%CATEGORICAL_V_os (bsymptom, B symptoms, '�Ȃ�');
%CATEGORICAL_V_os (weight, Weight loss, 'FALSE');
%CATEGORICAL_V_os (nsweats, Night sweats, 'FALSE');
%CATEGORICAL_V_os (fever, Fever, 'FALSE');
%CATEGORICAL_V_os (ldh, LDH IU/L, '<250');
%NUMERICAL_V_os (b2mg, ��2MG(mg/L));
%NUMERICAL_V_os (sil2r, ����sIL-2R);

ods rtf close;
ods pdf close;
ods graphics off;


ods graphics on;
ods pdf file="&out.\SAS\cox_dfs.pdf";
ods rtf file="&out.\SAS\cox_dfs.rtf";

%CATEGORICAL_V_dfs (agec, Age, '84<');
%CATEGORICAL_V_dfs (sex, Sex, '�j��');
%CATEGORICAL_V_dfs (ps, PS, '=<1');
%CATEGORICAL_V_dfs (stagec, Stage, '=<II');
%NUMERICAL_V_dfs (ipi, IPI);
%CATEGORICAL_V_dfs (marrow, Marrow involvement, '�A��');
%CATEGORICAL_V_dfs (bulky, Bulky disease, '�Ȃ�');
%CATEGORICAL_V_dfs (bulky_mass, Bulky mass, '�Ȃ�');
%CATEGORICAL_V_dfs (liver, ��_�a�ς̗L��, '�Ȃ�');
%CATEGORICAL_V_dfs (spleen, �B_�a�ς̗L��, '�Ȃ�');
%CATEGORICAL_V_dfs (kidney, �t_�a�ς̗L��, '�Ȃ�');
%CATEGORICAL_V_dfs (bsymptom, B symptoms, '�Ȃ�');
%CATEGORICAL_V_dfs (weight, Weight loss, 'FALSE');
%CATEGORICAL_V_dfs (nsweats, Night sweats, 'FALSE');
%CATEGORICAL_V_dfs (fever, Fever, 'FALSE');
%CATEGORICAL_V_dfs (ldh, LDH IU/L, '<250');
%NUMERICAL_V_dfs (b2mg, ��2MG(mg/L));
%NUMERICAL_V_dfs (sil2r, ����sIL-2R);

ods rtf close;
ods pdf close;
ods graphics off;
