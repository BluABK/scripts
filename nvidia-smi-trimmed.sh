#!/bin/bash
NV_SMI_RELEVANT_PART="$(nvidia-smi | tail -n $(expr $(nvidia-smi | wc -l) - 1))"
MIG_MODE_LINE="|                               |                      |               MIG M. |"
MIG_STATUS_LINE="|                               |                      |                  N/A |"
PCI_LINE="|   0  GeForce GTX 970     On   | 00000000:01:00.0  On |                  N/A |"
SECOND_DIVIDER_LINE="|=============================================================================|"

# Config
SHOW_MIG=0	# https://docs.nvidia.com/datacenter/tesla/mig-user-guide/#running-with-mig
SHOW_SECOND_DIVIDER_LINE=0

function nvidia-smi-trimmed() {
    # Let's remove that wasted space, for more tiling powah!
    
    NV_DIVIDER="$(echo "$NV_SMI_RELEVANT_PART" | head -n 1)"

	if [[ $SHOW_MIG -eq 1 ]]
	then
	    NV_UPPER="$(echo "$NV_SMI_RELEVANT_PART" | head -n 10)"
	else
	    NV_UPPER="$(echo "$NV_SMI_RELEVANT_PART" | head -n 10 | grep -v "$MIG_MODE_LINE" | grep -v "$MIG_STATUS_LINE")"
	fi
	
	if [[ $SHOW_SECOND_DIVIDER_LINE -eq 1 ]]
	then
		NV_LOWER="$(echo "$NV_SMI_RELEVANT_PART" | tail -n 18)"
	else
		NV_LOWER="$(echo "$NV_SMI_RELEVANT_PART" | grep -v $SECOND_DIVIDER_LINE | tail -n 16))"
	fi

    echo "$NV_UPPER"
    echo "$NV_DIVIDER"
    echo "$NV_LOWER"
}   

# Run function.
nvidia-smi-trimmed
