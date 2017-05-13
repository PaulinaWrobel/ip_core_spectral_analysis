FILENAME = '../../data/fin_6_CH1.dat';
%%
SF = 20e6;
N = 10e6;
% N = 100;
k = N/4;
W = 10;
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
