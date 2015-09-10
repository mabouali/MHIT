function meanByMonthYear=mhit_get_meanByMonthYear(discharge,year,yearList,month)
  meanByMonthYear=zeros(numel(yearList),12,class(discharge)); %#ok<ZEROLIKE>
  for yyyyID=1:numel(yearList)
    for mm=1:12
      meanByMonthYear(yyyyID,mm)=mhit_empty2nan( nanmean( discharge((year==yearList(yyyyID)) & (month==mm)) ) );
    end
  end 
end