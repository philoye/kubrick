def distance(fix1,fix2, unit = "m")
  return haversine_distance(fix1.lat.to_f, fix1.lng.to_f, fix2.lat.to_f, fix2.lng.to_f, unit)
end