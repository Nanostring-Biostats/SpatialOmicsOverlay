VALIDNAMES <- c("ROILabel", "Sample_ID", "Height", "Width", "X", "Y", 
                "Segmentation", "Position")

# Class definition
setClass("SpatialPosition",
         slots = c(position="data.frame"))

setMethod("show", signature = "SpatialPosition",
          function(object) {
              suppressWarnings(print(cbind(meta(object),
                                           Position=bookendStr(position(object)))))
          })

# Constructors
setGeneric("SpatialPosition",
           function(position)
               standardGeneric("SpatialPosition"))

setMethod("SpatialPosition", "missing",
          function(position)
          {
              position <- data.frame(matrix(integer(), nrow = 0L, 
                                            ncol = length(VALIDNAMES)))
              colnames(position) <- VALIDNAMES
              new2("SpatialPosition",
                   position = position)
          })

setMethod("SpatialPosition", "environment",
          function(position)
          {
              new2("SpatialPosition",
                   position = position)
          })

setMethod("SpatialPosition", "matrix",
          function(position)
          {
              new2("SpatialPosition",
                   position = as.data.frame(position))
          })

setMethod("SpatialPosition", "data.frame",
          function(position)
          {
              new2("SpatialPosition",
                   position = position)
          })


# Validity
setValidity2("SpatialPosition", function(object){
    msg <- NULL
    if (!all(VALIDNAMES %in% colnames(object@position))) {
        msg <- c(msg, "Column names in SpatialPosition are not valid")
    }
    if(nrow(object@position) > 0){
        numericCols <- c("Height", "Width", "X", "Y")
        stringCols <- c("ROILabel", "Sample_ID", "Segmentation", "Position")
        if(!all(apply(object@position[,numericCols], 2, class) == "numeric")){
            msg <- c(msg, "Numeric columns in SpatialPosition are not valid")
        }
        if(!all(apply(object@position[,stringCols], 2, class) == "character")){
            msg <- c(msg, "Character columns in SpatialPosition are not valid")
        }
        if(any(duplicated(object@position$Sample_ID))){
            msg <- c(msg, "All Sample_IDs in SpatialPosition must be unique")
        }
    }
    
    if (is.null(msg)) TRUE else msg
})


# Accessors
setGeneric("meta", signature = "object",
           function(object) standardGeneric("meta"))
setMethod("meta", "SpatialPosition", function(object) {
    object@position[,-(which(colnames(object@position) == "Position"))]})

setGeneric("position", signature = "object",
           function(object) standardGeneric("position"))
setMethod("position", "SpatialPosition", function(object){
    object@position[,which(colnames(object@position) == "Position")]})
    
setGeneric("spatialPos", signature = "object",
           function(object) standardGeneric("spatialPos"))
setMethod("spatialPos", "SpatialPosition", function(object){
    object@position})
