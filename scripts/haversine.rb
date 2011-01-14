#!/usr/bin/env ruby


class Location
	attr_accessor :latitude, :longitude
	MAXITERS = 20;

	def initialize(latitude,longitude)
		@latitude  = latitude
		@longitude = longitude
	end

	def compute_distance_and_bearing_to(location)
		results = [nil,nil]

		#	Convert lat/long to radians
		lat1 = self.latitude *  Math::PI / 180.0;
		lat2 = location.latitude * Math::PI / 180.0;
		lon1 = self.longitude * Math::PI / 180.0;
		lon2 = location.longitude * Math::PI / 180.0;

		a = 6378137.0; # WGS84 major axis
		b = 6356752.3142; # WGS84 semi-major axis
		f = (a - b) / a;
		aSqMinusBSqOverBSq = (a * a - b * b) / (b * b);
		javaL = lon2 - lon1;
		javaA = 0.0;
		javaU1 = Math.atan((1.0 - f) * Math.tan(lat1));
		javaU2 = Math.atan((1.0 - f) * Math.tan(lat2));
		cosU1 = Math.cos(javaU1);
		cosU2 = Math.cos(javaU2);
		sinU1 = Math.sin(javaU1);
		sinU2 = Math.sin(javaU2);
		cosU1cosU2 = cosU1 * cosU2;
		sinU1sinU2 = sinU1 * sinU2;
		sigma = 0.0;
		deltaSigma = 0.0;
		cosSqAlpha = 0.0;
		cos2SM = 0.0;
		cosSigma = 0.0;
		sinSigma = 0.0;
		cosLambda = 0.0;
		sinLambda = 0.0;
		javalambda = javaL; # initial guess

		iter = 0;
		while( iter < MAXITERS ) do
#		for(iter = 0; iter < MAXITERS; iter+=1) {
			lambdaOrig = javalambda;
			cosLambda = Math.cos(javalambda);
			sinLambda = Math.sin(javalambda);
			t1 = cosU2 * sinLambda;
			t2 = cosU1 * sinU2 - sinU1 * cosU2 * cosLambda;
			sinSqSigma = t1 * t1 + t2 * t2; # (14)
			sinSigma = Math.sqrt(sinSqSigma);
			cosSigma = sinU1sinU2 + cosU1cosU2 * cosLambda; # (15)
			sigma = Math.atan2(sinSigma, cosSigma); # (16)
			sinAlpha = (sinSigma == 0) ? 0.0 : cosU1cosU2 * sinLambda / sinSigma; # (17)
			cosSqAlpha = 1.0 - sinAlpha * sinAlpha;
			cos2SM = (cosSqAlpha == 0) ? 0.0 : cosSigma - 2.0 * sinU1sinU2 / cosSqAlpha; # (18)

			uSquared = cosSqAlpha * aSqMinusBSqOverBSq; # defn
			javaA = 1 + (uSquared / 16384.0) * # (3)
				(4096.0 + uSquared *
				(-768 + uSquared * (320.0 - 175.0 * uSquared)));
			javaB = (uSquared / 1024.0) * # (4)
				(256.0 + uSquared *
				(-128.0 + uSquared * (74.0 - 47.0 * uSquared)));
			javaC = (f / 16.0) *
				cosSqAlpha *
				(4.0 + f * (4.0 - 3.0 * cosSqAlpha)); # (10)
			cos2SMSq = cos2SM * cos2SM;
			deltaSigma = javaB * sinSigma * # (6)
				(cos2SM + (javaB / 4.0) *
				(cosSigma * (-1.0 + 2.0 * cos2SMSq) -
				(javaB / 6.0) * cos2SM *
				(-3.0 + 4.0 * sinSigma * sinSigma) *
				(-3.0 + 4.0 * cos2SMSq)));

			javalambda = javaL +
				(1.0 - javaC) * f * sinAlpha *
				(sigma + javaC * sinSigma *
				(cos2SM + javaC * cosSigma *
				(-1.0 + 2.0 * cos2SM * cos2SM))); # (11)

			delta = (javalambda - lambdaOrig) / javalambda;
#			if( Math.abs(delta) < 1.0e-12)
			if( delta.abs < 1.0e-12)
				break;
			end
			iter += 1;
		end

		distance = b * javaA * (sigma - deltaSigma);
		results[0] = distance;
		if( results.length > 1 )
			initialBearing = Math.atan2(cosU2 * sinLambda,
				cosU1 * sinU2 - sinU1 * cosU2 * cosLambda);
			initialBearing = initialBearing * 180.0 / Math::PI;
			results[1] = initialBearing;
			if( results.length > 2 )
				finalBearing = Math.atan2(cosU1 * sinLambda,
					-sinU1 * cosU2 + cosU1 * sinU2 * cosLambda);
				finalBearing = finalBearing * 180.0 / Math::PI;
				results[2] = finalBearing;
			end
		end
		results
	end

end

univ_and_mcgee   = Location.new( 37.87097 , -122.277557 );
hearst_and_mcgee = Location.new( 37.872732, -122.27775 );
hearst_and_sacra = Location.new( 37.872122, -122.282106 );
univ_and_sacra   = Location.new( 37.870479, -122.281848 );

puts univ_and_mcgee.compute_distance_and_bearing_to( hearst_and_mcgee )
puts hearst_and_mcgee.compute_distance_and_bearing_to( hearst_and_sacra )
puts hearst_and_sacra.compute_distance_and_bearing_to( univ_and_sacra )
puts univ_and_sacra.compute_distance_and_bearing_to( univ_and_mcgee )



univ_and_mcgee   = Location.new( 37.8711  , -122.27766 );
hearst_and_mcgee = Location.new( 37.872573, -122.277834 );
hearst_and_sacra = Location.new( 37.872071, -122.281976 );
univ_and_sacra   = Location.new( 37.870605, -122.281742 );

puts univ_and_mcgee.compute_distance_and_bearing_to( hearst_and_mcgee )
puts hearst_and_mcgee.compute_distance_and_bearing_to( hearst_and_sacra )
puts hearst_and_sacra.compute_distance_and_bearing_to( univ_and_sacra )
puts univ_and_sacra.compute_distance_and_bearing_to( univ_and_mcgee )





