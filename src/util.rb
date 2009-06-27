

# Linear interpolation (and, if clamp=false, extrapolation)
# 
# t = current time
# ta = start time
# tb = end time
# va = start value
# vb = end value
# 
def lerp( t, ta, tb, va, vb, clamp=true )
  t  = t.to_f
  ta = ta.to_f
  tb = tb.to_f
  
  blend = (t - ta)/(tb - ta)

  if( clamp )
    return va if blend <= 0.0   # too small
    return vb if blend >= 1.0   # too big
  end

  return (blend * (vb - va) + va)
  
end
