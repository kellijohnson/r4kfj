#' Create output necessary for plotting polygons
#' A function to find the beginings and endings of each run of real numbers
#' in a set of data, in order to create polygons for plotting. The assumption
#' is that ydata, ydata2, and xdata vectors are the same length, and that 
#' the ydata and ydata2 vectors contain NA values for missing data. The 
#' same values in ydata and ydata2 must be missing. The output will be 
#' a list of data frames of x and y values suitable for plotting polygons.
#' http://lukemiller.org/index.php/2012/12/generating-polygon-boundaries-for-plotting-simple-time-series-data-with-missing-data/
#' @author Kelli Faye Johnson
#' @author Luke Miller
#' @param xdata x axis data
#' @param ydata top of polygon
#' @param ydata2 bottom of polygon
#' @export

polylims = function(xdata, ydata, ydata2) {
    # Use rle function to find contiguous real numbers
    rl = rle(is.na(ydata))
    starts = vector()
    ends = vector()
    indx = 1
    for (i in 1:length(rl$lengths)){
        if (rl$values[i]){
            # Value was NA, advance index without saving the numeric values
            indx = indx + rl$lengths[i]
        } else {
            # Value was a real number, extract and save those values
            starts = c(starts,indx)
            ends = c(ends, (indx + rl$lengths[i] - 1))
            indx = indx + rl$lengths[i]
        }   
    }

    # At this point the lengths of the vectors 'starts' and 'ends' should be
    # equal, and each pair of values represents the starting and ending indices
    # of a continuous set of data in the ydata vector.

    # Next separate out each set of continuous ydata, and the associated xdata,
    # and format them for plotting as a polygon.
    polylist = list()
    for (i in 1:length(starts)){
        temp = data.frame(x = c(xdata[starts[i]],xdata[starts[i]:ends[i]],
                        rev(xdata[starts[i]:ends[i]])),
                y = c(ydata[starts[i]],ydata2[starts[i]:ends[i]],
                        rev(ydata[starts[i]:ends[i]])))
        polylist[[i]] = temp    
    }
    polylist
    # You can iterate through the items in polylist and plot them as 
    # polygons on your plot. Use code similar to the following:
    #   for (i in 1:length(polylist)){
    #           polygon(polylist[[i]]$x, polylist[[i]]$y, 
    #               col = rgb(0.5,0.5,0.5,0.5), border = NA)
    #   }
}