function [ out ] = guassCalc( x,y,T,t )
    out  =  exp(-1*(x.*x*T(1,1)+T(2,1)*x.*y+T(1,2)*x.*y+T(2,2)*y.*y)/(4*t));    
end