# cordic
COordinate Rotation DIgital Computer

Verilog implementation


#Note Programming FPGA on Mac OSX

error "Can't find iCE FTDI USB device (vendor_id 0x0403, device_id 0x6010)." while uploading code to FPGA (e.g., "iceprog example.bin")
You need to unload the FTDI driver (notes below are from Mountain Lion, 10.8.2). First check if it is running:

kextstat | grep FTDIUSBSerialDriver
If you see it on the kextstat, we need to unload it:

sudo kextunload -b com.FTDI.driver.FTDIUSBSerialDriver
Repeat the kextstat command and check that the driver was successfully unloaded.

Try running iceprog example.bin again. It should be working
