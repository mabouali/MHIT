function prefFun=mhit_getPrefFun(preference)
  switch (upper(preference))
    case 'MEAN'
      prefFun=@(x) nanmean(x);
    case 'MEDIAN'
      prefFun=@(x) nanmedian(x);
    otherwise
      error('preference must be either Mean or Median.');
  end
end
