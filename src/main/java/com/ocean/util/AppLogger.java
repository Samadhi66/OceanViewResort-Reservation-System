package com.ocean.util;

import java.util.logging.Level;
import java.util.logging.Logger;

public class AppLogger {
    public static final Logger LOG = Logger.getLogger("OceanViewResort");

    public static void info(String msg) { LOG.info(msg); }
    public static void warn(String msg) { LOG.warning(msg); }
    public static void error(String msg, Throwable t) { LOG.log(Level.SEVERE, msg, t); }
}