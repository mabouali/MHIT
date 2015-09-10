  function maxByMonthYear=mhit_get_maxByMonthYear(discharge,year,yearList,month)
    maxByMonthYear=zeros(numel(yearList),12,class(discharge)); %#ok<ZEROLIKE>
    for yyyyID=1:numel(yearList)
      for mm=1:12
        maxByMonthYear(yyyyID,mm)=mhit_empty2nan( nanmax( discharge((year==yearList(yyyyID)) & (month==mm)) ) );
      end
    end
  end
  