/**
  @file
  @brief Returns the modified datetime of a given file
         Works on Unix and Windows-based operating systems

  usage:
      %let dateModified = %mf_moddate(fpath=/some/location);

  @param fpath= full path of file to get modified datetime from
  @returns SAS datetime if file is found. 0 otherwise

  @version 9.2
  @author Jeremy Teoh
**/

%macro mf_getmoddate(fpath=
)/*/STORE SOURCE*/;
  %local retval rawval rc fref;
  %let rc=%sysfunc(filename(fref,&fpath));
  %let fid=%sysfunc(fopen(&fref));
  %if &rc ne 0 or &fid eq 0 %then %let retval=0;
  %else %do;
    /* windows */ 
    %let rawval=%qsysfunc(finfo(&fid,Last Modified));
    %let retval=%sysfunc(inputn(%str(&rawval), ANYDTDTM.)); 
    /* TODO: unix */
  %end;
  %let rc=%sysfunc(fclose(&fid));
  %let rc=%sysfunc(filename(fref));
  &retval
%mend;
