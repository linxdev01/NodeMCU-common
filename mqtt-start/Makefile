
# Check that given variables are set and all have non-empty values,
# die with an error otherwise.
#
# Params:
#   1. Variable name(s) to test.
#   2. (optional) Error message to print.
check_defined = \
	$(foreach 1,$1,$(__check_defined))
		__check_defined = \
			$(if $(value $1),, \
				$(error Undefined $1$(if $(value 2), ($(strip $2)))))

PORT   = 2323
TARGET = ${IP}:${PORT}
TTY    = ttyUSB0
SPEED  = 115200
DELAY  = 0.05

# Change to your program
NUPLOAD = nupload

.PHONY: upload upload-serial

upload:
	$(call check_defined, IP, IP of Target NodeMCU)
	@for i in `cat files.txt`;\
	do \
		(echo "Installing $$i"); \
		(${NUPLOAD} --ip ${TARGET} --delay ${DELAY} -c $$i $$i) || exit 1;\
		sleep 3;\
	done
	${NUPLOAD} --ip ${TARGET} --delay ${DELAY} init.lua
	${NUPLOAD} --ip ${TARGET} --list

upload-serial:
	@for i in `cat files.txt`;\
	do \
		(echo "Installing $$i"); \
		(nupload --bps ${SPEED} --delay ${DELAY} -c $$i $$i) || exit 1;\
		sleep 2;\
	done
	${NUPLOAD} --bps ${SPEED} --delay ${DELAY} init.lua
	${NUPLOAD} --ip ${TARGET} --list



