fw_app.bin:
	$(MAKE) --no-print-directory -C BOOTLOADER/ICPX_BL
	$(MAKE) --no-print-directory -C APP
	cat APP/obj/icopy_stm32_VS.bin BOOTLOADER/ICPX_BL/obj/icopy_stm32_BL.bin > fw_app.bin

fw_qc.bin:
	$(MAKE) --no-print-directory -C BOOTLOADER/ICPX_BL
	$(MAKE) --no-print-directory -C QCFW
	cat QCFW/obj/icopy_stm32_QC.bin BOOTLOADER/ICPX_BL/obj/icopy_stm32_BL.bin > fw_qc.bin

clean:
	$(MAKE) --no-print-directory -C BOOTLOADER/ICPX_BL clean
	$(MAKE) --no-print-directory -C APP clean
	$(MAKE) --no-print-directory -C QCFW clean
	rm -f fw_qc.bin fw_app.bin
