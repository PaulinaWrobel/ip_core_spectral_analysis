SF = 20e6;
N = 1e3;
k = 600;
integer = 32;
fraction = 16;

%%
FM = fimath;
FM.ProductWordLength = integer + fraction;
FM.ProductFractionLength = fraction;
FM.ProductMode = 'SpecifyPrecision';
FM.SumWordLength = integer + fraction;
FM.SumFractionLength = fraction;
FM.SumMode = 'SpecifyPrecision';
FM.RoundingMethod = 'Floor';
globalfimath(FM);

%%
NT = numerictype;
NT.Signedness = 'Signed';
NT.WordLength = integer + fraction;
NT.FractionLength = fraction;
