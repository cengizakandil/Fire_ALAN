## Creating the cumulative maps for using as human activity, later on the activity needs to be
##separated to industrial and urban
## methodology is basically the cumulative ALAN upto 2000 as that is the first year we have fire data
##then it follows and adds a year for every fire data and we use cum2013 to connect it to rest of the years 

rm(list=ls())
library(terra)
alan1992 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_1992_V1.tif")
alan1993 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_1993_V1.tif")
alan1994 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_1994_V1.tif")
alan1995 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_1995_V1.tif")
alan1996 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_1996_V1.tif")
alan1997 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_1997_V1.tif")
alan1998 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_1998_V1.tif")
alan1999 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_1999_V1.tif")
alan2000 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_2000_V1.tif")
alan2001 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_2001_V1.tif")
alan2002 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_2002_V1.tif")
alan2003 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_2003_V1.tif")
alan2004 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_2004_V1.tif")
alan2005 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_2005_V1.tif")
alan2006 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_2006_V1.tif")
alan2007 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_2007_V1.tif")
alan2008 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_2008_V1.tif")
alan2009 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_2009_V1.tif")
alan2010 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_2010_V1.tif")
alan2011 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_2011_V1.tif")
alan2012 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_2012_V1.tif")
alan2013 <- rast("D:/Chapter1/Zhao_dataset/Original_data/CCNL_DMSP_2013_V1.tif")
e <- c(-180, 180, 45, 78)
alan1992e <- crop(alan1992, e)
alan1993e <- crop(alan1993, e)
alan1994e <- crop(alan1994, e)
alan1995e <- crop(alan1995, e)
alan1996e <- crop(alan1996, e)
alan1997e <- crop(alan1997, e)
alan1998e <- crop(alan1998, e)
alan1999e <- crop(alan1999, e)
alan2000e <- crop(alan2000, e)
alan2001e <- crop(alan2001, e)
alan2002e <- crop(alan2002, e)
alan2003e <- crop(alan2003, e)
alan2004e <- crop(alan2004, e)
alan2005e <- crop(alan2005, e)
alan2006e <- crop(alan2006, e)
alan2007e <- crop(alan2007, e)
alan2008e <- crop(alan2008, e)
alan2009e <- crop(alan2009, e)
alan2010e <- crop(alan2010, e)
alan2011e <- crop(alan2011, e)
alan2012e <- crop(alan2012, e)
alan2013e <- crop(alan2013, e)

cum1999 <- alan1992e+ alan1993e+ alan1994e+ alan1995e+ alan1996e+ alan1997e+ alan1998e+ alan1999e
writeRaster(cum1999, "D:/Fire/data/ALAN/Cumulative/cum1999.tif")

cum2000 <- alan1992e+ alan1993e+ alan1994e+ alan1995e+ alan1996e+ alan1997e+ alan1998e+ alan1999e+ alan2000e
writeRaster(cum2000, "D:/Fire/data/ALAN/Cumulative/cum2000.tif")
cum2001 <- alan1992e+ alan1993e+ alan1994e+ alan1995e+ alan1996e+ alan1997e+ alan1998e+ alan1999e+ alan2000e+ alan2001e
writeRaster(cum2001, "D:/Fire/data/ALAN/Cumulative/cum2001.tif")
cum2002 <- alan1992e+ alan1993e+ alan1994e+ alan1995e+ alan1996e+ alan1997e+ alan1998e+ alan1999e+ alan2000e+ alan2001e+
  alan2002e
writeRaster(cum2002, "D:/Fire/data/ALAN/Cumulative/cum2002.tif")
cum2003 <- alan1992e+ alan1993e+ alan1994e+ alan1995e+ alan1996e+ alan1997e+ alan1998e+ alan1999e+ alan2000e+ alan2001e+
  alan2002e + alan2003e
writeRaster(cum2003, "D:/Fire/data/ALAN/Cumulative/cum2003.tif")
cum2004 <- alan1992e+ alan1993e+ alan1994e+ alan1995e+ alan1996e+ alan1997e+ alan1998e+ alan1999e+ alan2000e+ alan2001e+
  alan2002e + alan2003e +alan2004e
writeRaster(cum2004, "D:/Fire/data/ALAN/Cumulative/cum2004.tif")
cum2005 <- cum2004 + alan2005e
writeRaster(cum2005, "D:/Fire/data/ALAN/Cumulative/cum2005.tif")
cum2006 <- cum2005 + alan2006e
writeRaster(cum2006, "D:/Fire/data/ALAN/Cumulative/cum2006.tif")
cum2007 <- cum2006 + alan2007e
writeRaster(cum2007, "D:/Fire/data/ALAN/Cumulative/cum2007.tif")
cum2008 <- cum2007 + alan2008e
writeRaster(cum2008, "D:/Fire/data/ALAN/Cumulative/cum2008.tif")
cum2009 <- cum2008 + alan2009e
writeRaster(cum2009, "D:/Fire/data/ALAN/Cumulative/cum2009.tif")
cum2010 <- cum2009 + alan2010e
writeRaster(cum2010, "D:/Fire/data/ALAN/Cumulative/cum2010.tif")
cum2011 <- cum2010 + alan2011e
writeRaster(cum2011, "D:/Fire/data/ALAN/Cumulative/cum2011.tif")
cum2012 <- cum2011 + alan2012e
writeRaster(cum2012, "D:/Fire/data/ALAN/Cumulative/cum2012.tif")
cum2013 <- cum2012 + alan2013e
writeRaster(cum2013, "D:/Fire/data/ALAN/Cumulative/cum2013.tif")
