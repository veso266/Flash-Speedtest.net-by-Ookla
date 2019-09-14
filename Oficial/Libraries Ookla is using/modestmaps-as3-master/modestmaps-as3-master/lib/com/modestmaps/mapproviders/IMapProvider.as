/*
 * $Id$
 */

package com.modestmaps.mapproviders
{
	import com.modestmaps.core.Coordinate;
	import com.modestmaps.geo.Location;
	 
	public interface IMapProvider
	{
		/**
		 * @return an array of Strings urls (or URLRequests) for the images needed for this tile coordinate.
		 */ 
	    function getTileUrls(coord:Coordinate):Array;
	    	    
	   /**
	    * @return projected and transformed coordinate for a location.
	    */
	    function locationCoordinate(location:Location):Coordinate;
	    
	   /**
	    * @return untransformed and unprojected location for a coordinate.
	    */
	    function coordinateLocation(coordinate:Coordinate):Location;
	
	   /**
	    * Get top left outer-zoom limit and bottom right inner-zoom limits,
	    * as Coordinates in a two element array.
	    */
	    function outerLimits():/*Coordinate*/Array;
	
	   /**
	    * A string which describes the projection and transformation of a map provider.
	    */
	    function geometry():String;
	    
	    function toString():String;
	    
	   /**
	    * Munge coordinate for purposes of image selection and marker containment.
	    * E.g., useful for cylindical projections with infinite horizontal scroll.
	    */
	    function sourceCoordinate(coord:Coordinate):Coordinate;
	    
	    function get tileWidth():Number;
	    
	    function get tileHeight():Number;
	}
}