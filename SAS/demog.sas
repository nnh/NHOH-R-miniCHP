**************************************************************************
Program Name : demog.sas
Study Name : NHOH-R-miniCHP
Author : Kato Kiroku
Date : 2019-03-26
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
    datafile="&raw.\R-mini CHP_生年月日 性別.xlsx"
    dbms=xlsx replace;
    datarow=3;
run;

data perdata;
    set perdata;
    if b=6 then delete;
run;

%macro FMTNUM2CHAR (variable);
    %let dsid=%sysfunc(open(&SYSLAST.));
    %let varnum=%sysfunc(varnum(&dsid,&variable));
    %let fmt=%sysfunc(varfmt(&dsid,&varnum));
    %let dsid=%sysfunc(close(&dsid));
    &fmt
%mend FMTNUM2CHAR;

data dm;
    set libads.ptdata;
    if SUBJID=6 then delete;
run;

%macro IQR (name, var, rdata, title);

    %if &var in (in_lborres_ldh in_lborres_b2mg in_lborres_sil2r) %then %do;
      data dm_2;
          set dm;
          c=input(&var., best12.);
          if c=-1 then delete;
          keep c;
          rename c=&var.;
      run;
    %end;

    proc means data=&rdata noprint;
        var &var;
        output out=&name n=n mean=m std=s median=median q1=q1 q3=q3 min=min max=max;
    run;
    data &name;
        set &name;
        mean=strip(put(round(m, 0.1), 8.1));
        std=strip(put(round(s, 0.1), 8.1));
    run;

    data &name._frame;
        format characteristics grade $24. count percent $12.;
        characteristics=' ';
        grade=' ';
        count=' ';
        percent=' ';
        output;
    run;

    proc transpose data=&name out=&name._2;
        var n mean std median q1 q3 min max;
    run;

    data &name._3;
        merge &name._frame &name._2;
        if _N_=1 then characteristics="&title.";
        grade=upcase(_NAME_);
        count=col1;
        keep characteristics grade count percent;
    run;

%mend IQR;


%macro COUNT (name, var, form, a2z, title);

    %if "&name"="Marrow_involvement" %then %do;
      proc freq data=dm_2 noprint;
          tables &var / out=&name;
      run;
    %end;

    %if "&name"="sex" %then %do;
      proc freq data=perdata noprint;
          tables &var / out=&name;
      run;
    %end;

    %if "&name"="ipi_scores" %then %do;
      proc freq data=ipi noprint;
          tables &var / out=&name;
      run;
    %end;

    %if not(&name in (sex Marrow_involvement ipi_scores)) %then %do;
      proc freq data=dm noprint;
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
        format characteristics grade $24. &var &form count percent $12.;
        do &var=&a2z;
          characteristics=' ';
          grade=' ';
          count=' ';
          percent=' ';
          output;
        end;
    run;

    proc sort data=&name; by &var; run;
    proc sort data=&name._frame; by &var; run;

    data &name._2;
        merge &name._frame &name;
        by &var;
        %if &name in (sex in_b_select_3 in_b_select_2 in_b_select_1 ipi_scores) %then %do;
          grade=compress(&var.);
        %end;
        %if not(&name in (in_b_select_3 in_b_select_2 in_b_select_1 ipi_scores)) %then %do;
          grade=put(&var, %FMTNUM2CHAR(&var));
        %end;
        drop &var;
    run;

    %if "&name" NE "Marrow_involvement" %then %do;
      proc sort data=&name._2; by grade; run;
    %end;

    data &name._2;
        set &name._2;
        if _N_=1 then characteristics="&title.";
        if count=' ' then count='0';
        if percent=' ' then percent='0';
    run;

%mend COUNT;


*Number of patients;
data nop;
    format characteristics grade $24. count percent $12.;
    set dm end=last;
    characteristics='Number of patients';
    retain c 0;
    c+1;
    if last;
    grade=' ';
    count=strip(put(c, best12.));
    percent=' ';
    keep characteristics grade count percent;
run;

*Age;
data perdata_2;
    set perdata;
    format c YYMMDD10.;
    keep b c;
    rename b=SUBJID c=borndate;
run;
data dm_2;
    set dm;
    id=input(SUBJID, best12.);
    keep id reg_day;
    rename id=SUBJID;
run;
data age_tmp;
    merge perdata_2 dm_2;
    by SUBJID;
    if SUBJID=6 then delete;
    reg_age=intck('YEAR', borndate, reg_day);
    if (month(reg_day)<month(borndate)) then reg_age=reg_age-1;
    else if (month(reg_day)=month(borndate))
              and day(reg_day)<day(borndate) then reg_age=reg_age-1;
run;
%IQR (age, reg_age, age_tmp, AGE);
    
*Sex;
%COUNT (sex, f, $24., %str('男性', '女性'), SEX);

*PS;
%COUNT (PS, in_qsorres_ps, FMT_7_F1., %str(1 to 3, 5), PS);

*Stage;
%COUNT (Stage, in_patholo_ctg, FMT_6_F5., 1 to 7, Stage);

*Marrow involvement;
data dm_2;
    set dm;
    if in_bmp_lesions=2 then x=2;
    if in_bmp_lesions=1 then do;
      if in_bmb_lesions=1 then x=1;
      else if in_bmb_lesions=2 then x=2;
      else if in_bmb_lesions=3 then x=1;
      else x=1;
    end;
    if in_bmp_lesions=3 then do;
      if in_bmb_lesions=1 then x=1;
      else if in_bmb_lesions=2 then x=2;
      else if in_bmb_lesions=3 then x=3;
      else x=3;
    end;
    format x FMT_23_F6.;
    keep in_bmp_lesions in_bmb_lesions x;
run;
%COUNT (Marrow_involvement, x, FMT_23_F6., 1 to 3, Marrow involvement);

*Bulky disease;
%COUNT (Bulky_disease, in_bulky_yn, FMT_14_F4., 1 to 2, Bulky disease);

*Extra nodal disease;
    *Liver;
    %COUNT (end1, in_liver_yn, FMT_14_F4., 1 to 2, 肝_病変の有無);
    *Spleen;
    %COUNT (end2, in_spleen_yn, FMT_14_F4., 1 to 2, 脾_病変の有無);
    *Kidney;
    %COUNT (end3, in_renal_yn, FMT_14_F4., 1 to 2, 腎_病変の有無);

*B symptoms;
    %COUNT (bsym, in_b_yn, FMT_14_F4., 1 to 2, B symptoms);
    *Weight loss;
    %COUNT (weight, in_b_select_3, $24., %str('TRUE', 'FALSE'), Weight loss);
    *Night sweats;
    %COUNT (sweat, in_b_select_2, $24., %str('TRUE', 'FALSE'), Night sweats);
    *Fever;
    %COUNT (fever, in_b_select_1, $24., %str('TRUE', 'FALSE'), Fever);

*LDH IU/L;
data ldh;
    length grade $24;
    set dm;
    c=input(in_lborres_ldh, best12.);
    if c=-1 then delete;
    else if c<250 then grade='<250';
    else if c>=250 then grade='250=<';
    keep subjid c grade;
    rename c=in_lborres_ldh;
run;
proc freq data=ldh noprint;
    table grade / out=ldh_2;
run;
data ldh_2;
    set ldh_2;
    c=strip(input(count, $12.));
    p=strip(put(round(percent, 0.1), 8.1));
    drop count percent;
    rename c=count p=percent;
run;
data ldh_frame;
    format characteristics grade $24. count percent $12.;
    characteristics=' ';
    grade=' ';
    count=' ';
    percent=' ';
    output;
run;
data ldh_3;
    merge ldh_frame ldh_2;
    if _N_=1 then characteristics='LDH IU/L';
    percent=round(percent, 0.1);
    keep characteristics grade count percent;
run;

*β2MG(mg/L);
    %IQR (beta, in_lborres_b2mg, dm_2, β2MG(mg/L));
*Serum sIL-2R;
    %IQR (sil, in_lborres_sil2r, dm_2, 血清sIL-2R);

*IPI scores;
data ipi_1;
    set age_tmp;
    if reg_age>=61 then p1=1; else p1=0;
run;
data ipi_2;
    set ldh;
    if grade='250=<' then p2=1;
    else if grade='<250' then p2=0;
    id=input(subjid, best12.);
    drop subjid;
    rename id=subjid;
run;
data ipi_3_4_5;
    set dm;
    if in_patholo_ctg in (3, 4) then p3=1;
    else p3=0;
    if in_liver_yn=1 then do;
      if in_spleen_yn=1 then p4=1;
      if in_spleen_yn=2 then do;
        if in_renal_yn=1 then p4=1;
        else p4=0;
      end;
    end;
    if in_liver_yn=2 then do;
      if in_spleen_yn=1 then do;
        if in_renal_yn=1 then p4=1;
        else p4=0;
      end;
      if in_spleen_yn=2 then p4=0;
    end;
    if in_qsorres_ps in (2, 3) then p5=1;
    else p5=0;
    id=input(subjid, best12.);
    keep id p3 p4 p5;
    rename id=subjid;
run;
data ipi;
    merge ipi_1 ipi_2 ipi_3_4_5;
    by subjid;
    ipi=sum(of p1 - p5);
    keep ipi;
run;
%COUNT (ipi_scores, ipi, best12., 1 to 5, IPI scores);

data demog;
    set nop age_3 sex_2 PS_2 Stage_2 IPI_scores_2 Marrow_involvement_2 Bulky_disease_2 
          end1_2 end2_2 end3_2 bsym_2 weight_2 sweat_2 fever_2 ldh_3 beta_3 sil_3;
run;

proc export data=demog
    outfile="&out.\SAS\demog.csv"
    dbms=csv replace;
run;
