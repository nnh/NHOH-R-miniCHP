**************************************************************************
Program Name : coxds.sas
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


*years_pfs; *censor_pfs;
data years_censor_pfs;
    set dm;
    if subjid='34' then surv_dy=DSDTC;
    keep SUBJID ds_epoch fs1_ECRFTDTC rec1_yn rec1_dy prog_yn rprog_dy dd_flg DDDTC surv_flg surv_dy DSTERM fs1_ECENDTC fs4_ECENDTC;
run;
data years_censor_pfs_2;
    set years_censor_pfs;
    if rec1_yn=1 and prog_yn=1 then do;
      if rec1_dy<=rprog_dy then earliest=rec1_dy;
      if rprog_dy<=rec1_dy then earliest=rprog_dy;
      censor_pfs=0;
    end;
    if rec1_yn=1 and prog_yn=2 then do;
      earliest=rec1_dy;
      censor_pfs=0;
    end;
    if rec1_yn=2 and prog_yn=1 then do;
      earliest=rprog_dy;
      censor_pfs=0;
    end;
    if rec1_yn=2 and prog_yn=2 and dd_flg='1' then do;
      earliest=DDDTC;
      censor_pfs=0;
    end;
    if rec1_yn=2 and prog_yn=2 and dd_flg=' ' and surv_dy NE . then do;
      earliest=surv_dy;
      censor_pfs=1;
    end;
    if DSTERM=16 and ds_epoch=1 then do;
      if earliest<=fs1_ECENDTC then earliest=earliest;
      else if fs1_ECENDTC<=earliest then earliest=fs1_ECENDTC;
    end;
    if DSTERM=16 and ds_epoch=4 then do;
      if earliest<=fs4_ECENDTC then earliest=earliest;
      else if fs4_ECENDTC<=earliest then earliest=fs4_ECENDTC;
    end;
    keep subjid fs1_ECRFTDTC earliest censor_pfs;
run;
data z_years_censor_pfs;
    set years_censor_pfs_2;
    day=earliest-fs1_ECRFTDTC;
    years_pfs=(day/365);
    keep subjid censor_pfs years_pfs;
run;
proc sort data=z_years_censor_pfs; by subjid; run;


*years_os; *censor_os;
data years_censor_os;
    set dm;
    if subjid='6' then delete;
    if subjid='34' then surv_dy=DSDTC;
    keep SUBJID fs1_ECRFTDTC dd_flg DDDTC surv_dy;
run;
data z_years_censor_os;
    set years_censor_os;
    if dd_flg=1 then do;
      day=DDDTC-fs1_ECRFTDTC;
      censor_os=0;
    end;
    if dd_flg NE 1 then do;
      day=surv_dy-fs1_ECRFTDTC;
      censor_os=1;
    end;
    years_os=(day/365);
    keep subjid censor_os years_os;
run;
proc sort data=z_years_censor_os; by subjid; run;


*years_dfs; *censor_dfs;
data years_censor_dfs;
    set dm;
    if subjid='6' then delete;
    if subjid='34' then surv_dy=DSDTC;
    keep SUBJID ds_epoch fs1_ECRFTDTC rec1_yn rec1_dy prog_yn rprog_dy dd_flg DDDTC surv_flg surv_dy DSTERM fs1_ECENDTC fs4_ECENDTC DDORRES;
run;
data years_censor_dfs_2;
    set years_censor_dfs;
    if rec1_yn=1 and prog_yn=1 then do;
      if rec1_dy<=rprog_dy then earliest=rec1_dy;
      if rprog_dy<=rec1_dy then earliest=rprog_dy;
      censor_dfs=0;
    end;
    if rec1_yn=1 and prog_yn=2 then do;
      earliest=rec1_dy;
      censor_dfs=0;
    end;
    if rec1_yn=2 and prog_yn=1 then do;
      earliest=rprog_dy;
      censor_dfs=0;
    end;
    if rec1_yn=2 and prog_yn=2 and dd_flg='1' then do;
      if DDORRES=3 then do;
        earliest=DDDTC;
        censor_dfs=1;
      end;
      else do;
        earliest=DDDTC;
        censor_dfs=0;
      end;
    end;
    if rec1_yn=2 and prog_yn=2 and dd_flg=' ' and surv_dy NE . then do;
      earliest=surv_dy;
      censor_dfs=1;
    end;
    if DSTERM=16 and ds_epoch=1 then do;
      if earliest<=fs1_ECENDTC then earliest=earliest;
      else if fs1_ECENDTC<=earliest then earliest=fs1_ECENDTC;
     end;
    if DSTERM=16 and ds_epoch=4 then do;
       if earliest<=fs4_ECENDTC then earliest=earliest;
      else if fs4_ECENDTC<=earliest then earliest=fs4_ECENDTC;
    end;
    keep fs1_ECRFTDTC earliest censor_dfs subjid;
run;
data z_years_censor_dfs;
    set years_censor_dfs_2;
    day=earliest-fs1_ECRFTDTC;
    years_dfs=(day/365);
    keep subjid censor_dfs years_dfs;
run;
proc sort data=z_years_censor_dfs; by subjid; run;


*age; *sex;
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
    keep id f reg_age agec;
    rename id=subjid;
run;
proc sort data=z_age_sex; by subjid; run;


*PS stage bulky liver spleen kidney(renal) Bsymptoms weightloss nsweats fever É¿2MG sIL-2R;
data z_others;
    format subjid in_qsorres_ps in_patholo_ctg stagec in_bulky_yn bulky_mass in_liver_yn in_spleen_yn in_renal_yn
            in_b_yn in_b_select_3 in_b_select_2 in_b_select_1 in_lborres_b2mg in_lborres_sil2r;
    set dm;
    format ps stagec bulky_mass $8.;
    if in_qsorres_ps in (5, 1) then ps='=<1';
    else if in_qsorres_ps in (2, 3) then ps='=>2';
    if in_patholo_ctg in (1, 2, 5, 6) then stagec='=<II';
    else if in_patholo_ctg in (3, 4, 7) then stagec='=>III';
    if in_liver_yn=2 and in_spleen_yn=2 and in_renal_yn=2 then bulky_mass='Ç»Çµ';
    if bulky_mass=' ' then bulky_mass='Ç†ÇË';
    b2mg=input(in_lborres_b2mg, best12.);
    sil2r=input(in_lborres_sil2r, best12.);
    if b2mg=-1 then call missing(b2mg);
    keep subjid ps in_patholo_ctg stagec in_bulky_yn bulky_mass in_liver_yn in_spleen_yn in_renal_yn
            in_b_yn in_b_select_3 in_b_select_2 in_b_select_1 b2mg sil2r;
run;
proc sort data=z_others; by subjid; run;


*Marrow involvement;
data z_marrow;
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
    keep subjid x;
run;
proc sort data=z_marrow; by subjid; run;

*LDH IU/L;
data z_ldh;
    length grade $24;
    set dm;
    c=input(in_lborres_ldh, best12.);
    if c=-1 then delete;
    else if c<250 then grade='<250';
    else if c>=250 then grade='250=<';
    keep subjid grade;
run;
proc sort data=z_ldh; by subjid; run;


*IPI scores;
data ipi_1;
    set age_sex;
    if reg_age>=61 then p1=1; else p1=0;
run;
data ipi_2;
    set z_ldh;
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
proc sort data=ipi_1; by subjid; run;
proc sort data=ipi_2; by subjid; run;
proc sort data=ipi_3_4_5; by subjid; run;
data z_ipi;
    format id $4.;
    merge ipi_1 ipi_2 ipi_3_4_5;
    by subjid;
    ipi=sum(of p1 - p5);
    id=strip(put(subjid, best12.));
    keep ipi id;
    rename id=subjid;
run;
proc sort data=z_ipi; by subjid; run;


data coxds; 
    format subjid years_pfs censor_pfs years_os censor_os years_dfs censor_dfs
               reg_age agec f ps in_patholo_ctg stagec ipi x in_bulky_yn bulky_mass
               in_liver_yn in_spleen_yn in_renal_yn in_b_yn in_b_select_3 in_b_select_2 in_b_select_1
               grade b2mg sil2r;
    merge z_years_censor_pfs z_years_censor_os z_years_censor_dfs z_age_sex z_others z_marrow z_ldh z_ipi;
    by subjid;
    rename reg_age=age f=sex in_patholo_ctg=stage x=marrow in_bulky_yn=bulky
                 in_liver_yn=liver in_spleen_yn=spleen in_renal_yn=kidney in_b_yn=bsymptom
                 in_b_select_3=weight in_b_select_2=nsweats in_b_select_1=fever grade=ldh;
    label f='sex';
run;

proc sort data=coxds out="&cwd.\input\ads\SAS\coxds"
    sortseq=linguistic (numeric_collation=on);
    by subjid;
run;

proc sort data=coxds
    sortseq=linguistic (numeric_collation=on);
    by subjid;
run;

proc export data=coxds
    outfile="&cwd.\input\ads\SAS\coxds.csv"
    dbms=csv replace;
run;
