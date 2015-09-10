function output=mhit_empty2nan(input)
if (isempty(input))
  output=NaN;
else
  output=input;
end
end