#!../../bin/linux-x86_64/sr570

< envPaths
< /epics/common/xf03idc-ioc2-netsetup.cmd

epicsEnvSet("ENGINEER",  "klauer x3615")
epicsEnvSet("LOCATION",  "HXN 3IDC")

epicsEnvSet "SYS" "XF:03IDC-CT"
epicsEnvSet("IOC_PREFIX", "$(SYS){IOC:$(IOCNAME)}")


###############################################################################
epicsEnvSet("DEV1", "{SR570:1}")
epicsEnvSet("DEV2", "{SR570:2}")
epicsEnvSet("DEV3", "{SR570:3}")
epicsEnvSet("DEV4", "{SR570:4}")
epicsEnvSet("DEV5", "{SR570:5}")

## Register all support components
dbLoadDatabase("$(TOP)/dbd/sr570.dbd",0,0)
sr570_registerRecordDeviceDriver(pdbbase)

###############################################################################
# Set up ASYN ports
# SR570:1
epicsEnvSet("PORT", "SR1")
#drvAsynIPPortConfigure("$(PORT)","xf03idc-tsrv2.nsls2.bnl.local:4009",0,0,0)
drvAsynIPPortConfigure("$(PORT)","xf03idc-tsrv6.nsls2.bnl.local:4001",0,0,0)
< conf_port.cmd

# SR570:2
epicsEnvSet("PORT", "SR2")
#drvAsynIPPortConfigure("$(PORT)","xf03idc-tsrv3.nsls2.bnl.local:4013",0,0,0)
drvAsynIPPortConfigure("$(PORT)","xf03idc-tsrv6.nsls2.bnl.local:4002",0,0,0)
< conf_port.cmd

# SR570:3
epicsEnvSet("PORT", "SR3")
#drvAsynIPPortConfigure("$(PORT)","xf03idc-tsrv3.nsls2.bnl.local:4010",0,0,0)
drvAsynIPPortConfigure("$(PORT)","xf03idc-tsrv6.nsls2.bnl.local:4003",0,0,0)
< conf_port.cmd

# SR570:4
epicsEnvSet("PORT", "SR4")
#drvAsynIPPortConfigure("$(PORT)","xf03idb-tsrv2.nsls2.bnl.local:4002",0,0,0)
drvAsynIPPortConfigure("$(PORT)","xf03idc-tsrv6.nsls2.bnl.local:4004",0,0,0)
< conf_port.cmd

# SR570:5
# epicsEnvSet("PORT", "SR5")
#drvAsynIPPortConfigure("$(PORT)","xf03idc-tsrv6.nsls2.bnl.local:4005",0,0,0)
# < conf_port.cmd

# SR570:6
# epicsEnvSet("PORT", "SR6")
# drvAsynIPPortConfigure("$(PORT)","10.3.2.xx:4009",0,0,0)
# < conf_port.cmd

###############################################################################
## Load record instances
dbLoadRecords("$(TOP)/db/SR570.db", "P=$(SYS),A=$(DEV1),PORT=SR1")
dbLoadRecords("$(TOP)/db/SR570.db", "P=$(SYS),A=$(DEV2),PORT=SR2")
dbLoadRecords("$(TOP)/db/SR570.db", "P=$(SYS),A=$(DEV3),PORT=SR3")
dbLoadRecords("$(TOP)/db/SR570.db", "P=$(SYS),A=$(DEV4),PORT=SR4")
# dbLoadRecords("$(TOP)/db/SR570.db", "P=$(SYS),A=$(DEV5),PORT=SR5")

dbLoadRecords("$(EPICS_BASE)/db/save_restoreStatus.db","P=$(IOC_PREFIX)")
dbLoadRecords("$(EPICS_BASE)/db/iocAdminSoft.db","IOC=$(IOC_PREFIX)")

save_restoreSet_Debug(0)
save_restoreSet_IncompleteSetsOk(1)
save_restoreSet_DatedBackupFiles(1)

set_savefile_path("${TOP}/as","/save")
set_requestfile_path("${TOP}/as","/req")
set_requestfile_path("${EPICS_BASE}/as","/req")

system("install -m 777 -d ${TOP}/as/save")
system("install -m 777 -d ${TOP}/as/req")

set_pass0_restoreFile("SR570preamp_settings.sav")
set_pass1_restoreFile("SR570preamp_settings.sav")

save_restoreSet_status_prefix("$(IOC_PREFIX)")
# asSetFilename("/cf-update/acf/default.acf")

iocInit()

create_monitor_set("SR570preamp_settings.req", 30, "P=$(SYS),A=$(DEV1)")
create_monitor_set("SR570preamp_settings.req", 30, "P=$(SYS),A=$(DEV2)")
create_monitor_set("SR570preamp_settings.req", 30, "P=$(SYS),A=$(DEV3)")
create_monitor_set("SR570preamp_settings.req", 30, "P=$(SYS),A=$(DEV4)")
# create_monitor_set("SR570preamp_settings.req", 30, "P=$(SYS),A=$(DEV5)")

cd ${TOP}
dbl > ./records.dbl
system "cp ./records.dbl /cf-update/$HOSTNAME.$IOCNAME.dbl"
