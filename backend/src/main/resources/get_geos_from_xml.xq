xquery version "3.0";

(:~
: XQuery for extracting the latitude and longitude from an xml generated from {@code http://www.geoplaner.com/}
:
: This can be used with an XML database like BaseX. BaseX can execute this query.
:
: User: gborza
: Date: 03/04/2014
: Time: 21:45
:)

let $d := doc("route1.xml")

for $e in $d/gpx/rte/rtept
  return fn:concat($e/@lat,',',$e/@lon,'\n')