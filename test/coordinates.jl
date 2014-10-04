# Test Coordinate Transforms
module TestCoordinates

using OpenStreetMap
using Base.Test

# Point in LLA
lat = 42.3673;
lon = -71.0960;
alt = 0;
P_lla = OpenStreetMap.LLA(lat, lon, alt)

@test P_lla.lat == lat
@test P_lla.lon == lon
@test P_lla.alt == alt

# Reference point in LLA
lat0 = 42.36299;
lon0 = -71.09183;
alt0 = 0;
P_ref_lla = OpenStreetMap.LLA(lat0, lon0, alt0)

# lla2ecef
P_ecef = lla2ecef(P_lla)

@test_approx_eq P_ecef.x 1529073.1560519305
@test_approx_eq P_ecef.y -4465040.019013103
@test_approx_eq P_ecef.z 4275835.339260309

# lla2enu
P_enu = lla2enu(P_lla, P_ref_lla)

@test_approx_eq P_enu.east -343.49374908345493
@test_approx_eq_eps P_enu.north 478.7648554687071 1e-8
@test_approx_eq_eps P_enu.up -0.027242884564486758 1e-8

#####
# Bounds object
bounds = OpenStreetMap.Bounds(42.365, 42.3695, -71.1, -71.094)
bounds_enu = lla2enu(bounds)

@test_approx_eq bounds_enu.min_y -249.92653559014204
@test_approx_eq bounds_enu.max_y 249.9353534127322
@test_approx_eq bounds_enu.min_x -247.1091823451915
@test_approx_eq bounds_enu.max_x 247.1268196141778

end # module TestCoordinates
