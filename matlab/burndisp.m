function burndisp(ts, ytrue, order, hybrid, sparsetree, perfecttree)

if nargin<6 || isempty(perfecttree)
    perfecttree = false;
end

if nargin<5 || isempty(sparsetree)
    sparsetree = false;
end

if  nargin<4 || isempty(hybrid)
    hybrid = false;
end

if  nargin<3 || isempty(order)
    order = 0;
end

if sparsetree && perfecttree
    error('Two last input arguments cannot both evaluate to true.')
end

skipline()

if order==0
    disp('Extended path')
else
    if sparsetree
        if hybrid
            dprintf('Stochastic extended path (order=%u, hybrid, sparse tree)', order)
        else
            dprintf('Stochastic extended path (order=%u, sparse tree)', order)
        end
    else
        if hybrid
            dprintf('Stochastic extended path (order=%u, hybrid, perfect tree)', order)
        else
            dprintf('Stochastic extended path (order=%u, perfect tree)', order)
        end
    end
end

data = ts.data(2:end,1);
ytrue = ytrue(1:length(data));

dprintf('MEAN: %.6f', mean(data))
dprintf('STD.: %.6f', sqrt(var(data)))
dprintf('mean(abs(diff)) %%: %.6f', 100*mean(abs(data-transpose(ytrue))./transpose(ytrue)));
dprintf('.min(abs(diff)) %%: %.6f', 100*min(abs(data-transpose(ytrue))./transpose(ytrue)));
dprintf('.max(abs(diff)) %%: %.6f', 100*max(abs(data-transpose(ytrue))./transpose(ytrue)));

skipline()
