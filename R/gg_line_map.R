#' Create a gg style line map using BUSCO coordinates
#' 
#' @param busc A data.frame of BUSCO coordinates with Busco_ids as row.names.
#' @param rect A logical indicating if a rectangle should be drawn from the lowest to highest BUSCO.
#' @param palpha A number [0-1] for point alpha channel (transparency).
#' @param size A number to adjust point size.
#' @param lalpha A number [0-1] for line alpha channel (transparency).
#' @param linewidth A number to adjust line width.
#' @param line_na_rm A logical indicating if lines should end at missing points.
#' @param check_table Logical to perform check for a properly formatted BUSCO table.
#' 
#' @returns A ggplot object.
#' 
#' @importFrom magrittr "%>%"
#' 
#' @examples
#' DM6file <- system.file("extdata", "DM6_full_table.tsv.gz", package = 'BUSCOplot')
#' DM6 <- read_busco(DM6file)
#' chromL <- make_known(DM6, sample_name = "DM6:")
#' #lapply(chromL[1:2], head, n=2)
#' ATLfile <- system.file("extdata", "atlantic_full_table.tsv.gz", package = 'BUSCOplot')
#' ATL <- read_busco(ATLfile)
#' chromL <- add_unknown(known_list = chromL, unknown_df = ATL, sample_name = "ATL:")
#' #lapply(chromL[1:2], head, n=2)
#' 
#' gg_line_map(chromL[[1]])
#' 
#' 
#' @export
gg_line_map <- function( busc, 
                         rect = FALSE, 
                         palpha = 1.0, size = 1.0,
                         lalpha = 1.0, linewidth = 1.0,
                         line_na_rm = TRUE,
                         check_table = TRUE){
#  library(tidyr)
#  library(dplyr)
#  library(ggplot2)
#  library(viridisLite)
  
  if( check_table == TRUE ){
    check_busco_table(busc)
    if( length( unique( busc$Sequence ) ) != 1 ){
      stop("Sequence column is expected to contain a single unique value.")
    }
    colnames(busc)[4] <- unique( busc$Sequence )
    busc <- busc[ , c(4, 9:ncol(busc))]
  } else {
    warning( "Check for BUSCO table disabled, the user is responsible for results!" )
  }
  
  chr_width <- 0.2
  rect_df <- data.frame(xmin = 1:ncol(busc) - chr_width, 
                        xmax = 1:ncol(busc) + chr_width,
                        ymin = apply(busc, MARGIN = 2, FUN = min, na.rm = TRUE),
                        ymax = apply(busc, MARGIN = 2, FUN = max, na.rm = TRUE))
  # rect_df$ymin <- rect_df$ymin * 0.6
  # rect_df$ymax <- rect_df$ymax * 1.01
  rect_df$ymin <- rect_df$ymin - 0.5e6
  rect_df$ymax <- rect_df$ymax + 0.5e6
  
  #aes(xmin = 1, xmax = 3, ymin = 10, ymax = 15)
  busc <- data.frame( Busco_id = rownames(busc), busc)
  vars <- colnames(busc)
  
  data_long <- busc %>%
    dplyr::select(tidyselect::all_of(vars)) %>% 
    tidyr::pivot_longer( cols = vars[-1] )
  
  names(data_long)[2:3] <- c("Sample", "POS")
  data_long$Sample <- factor(data_long$Sample , levels = unique(data_long$Sample))
  if( line_na_rm == TRUE ){
    #cat(paste("line_na_rm:", line_na_rm))
    data_long <- data_long[ !is.na(data_long$POS), ]
  }
  
  Sample <- POS <- Busco_id <- NULL
  #p <- ggplot2::ggplot(data_long, ggplot2::aes(x = data_long$Sample, y = data_long$POS, color = data_long$Busco_id, group = data_long$Busco_id)) + 
  p <- ggplot2::ggplot(data_long, ggplot2::aes(x = Sample, y = POS, color = Busco_id, group = Busco_id)) + 
    ggplot2::geom_point( size = size, alpha = palpha ) +
    ggplot2::geom_line( linewidth = linewidth,
               #alpha = 0.1,
               alpha = lalpha,
               na.rm = line_na_rm )
  #  p <- p + geom_rect( data = rect_df, mapping = aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax))
  # p <- p + annotate( geom = "rect",
  #                    xmin = rect_df$xmin, xmax = rect_df$xmax,
  #                    ymin = rect_df$ymin, ymax = rect_df$ymax,
  #                    alpha = .2, fill = "blue")
  #p <- p + scale_color_manual( values = rep(viridisLite::magma( n = 8, alpha = 0.8 ), times = 1e6) )
  p <- p + ggplot2::scale_color_manual( values = rep(viridisLite::magma( n = 8, alpha = 1 ), times = 1e6) )
  p <- p + ggplot2::theme_bw()
  #p <- p + xlab("")
  p <- p + ggplot2::ylab("Position (Mbp)")
  p <- p + ggplot2::theme(legend.position = "none")
  p <- p + ggplot2::theme(axis.title.x = ggplot2::element_blank(), 
                 axis.text.x = ggplot2::element_text(angle = 60, hjust = 1, size = 12))
  #  p <- p + scale_y_continuous( breaks = seq(0, 1e9, by = 10e6),
  #                               labels = seq(0, 1e9, by = 10e6)/1e6,
  #                               minor_breaks = seq(0, 1e9, by = 5e6) )
  p <- p + ggplot2::scale_y_continuous( breaks = seq(-1e9, 1e9, by = 10e6),
                               labels = seq(-1e9, 1e9, by = 10e6)/1e6,
                               minor_breaks = seq(-1e9, 1e9, by = 5e6) )
  if(rect == TRUE){
    p <- p + ggplot2::annotate( geom = "rect",
                       xmin = rect_df$xmin, xmax = rect_df$xmax,
                       ymin = rect_df$ymin, ymax = rect_df$ymax,
                       fill = "#0000ff22", color = "#00000088", linewidth = 0.5)
  }
  
  return(p)
}

