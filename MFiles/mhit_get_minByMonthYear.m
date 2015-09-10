function minByMonthYear=mhit_get_minByMonthYear(discharge,year,yearList,month)
  minByMonthYear=zeros(numel(yearList),12,class(discharge)); %#ok<ZEROLIKE>
  for yyyyID=1:numel(yearList)
    for mm=1:12
      minByMonthYear(yyyyID,mm)=mhit_empty2nan( nanmin( discharge((year==yearList(yyyyID)) & (month==mm)) ) );
    end
  end 
end