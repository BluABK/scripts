#!/bin/bash
NV_SMI_TRIMMED="$HOME/scripts/nvidia-smi-trimmed.sh"
NV_SMI_TRIMMED_LINES="$($NV_SMI_TRIMMED | wc -l)"
LINE_LEN="$($NV_SMI_TRIMMED | wc -c)" # Usually 80
LINE_CUTLEN="$(expr $LINE_LEN - 2)"

function nvidia-smi-trimmed() {
    # Let's remove that wasted space, for more tiling powah!
    
    NV_DIVIDER="$(echo "$NV_SMI_RELEVANT_PART" | head -n 1)"

        if [[ $SHOW_MIG -eq 1 ]]
        then
            NV_UPPER="$(echo "$NV_SMI_RELEVANT_PART" | head -n 10)"
        else
            NV_UPPER="$(echo "$NV_SMI_RELEVANT_PART" | head -n 10 | grep -v "$MIG_MODE_LINE" | grep -v "$MIG_STATUS_LINE")"
        fi
    
        NV_LOWER="$(echo "$NV_SMI_RELEVANT_PART" | tail -n 18)"

    echo "$NV_UPPER"
    echo "$NV_DIVIDER"
    echo "$NV_LOWER"
}

function nvidia-smi-trimmed-borderless() {
	# Remove top and bottom dividers.
	OUT="$($NV_SMI_TRIMMED | \
		tail -n $(expr $NV_SMI_TRIMMED_LINES - 1) | \
		head -n $(expr $NV_SMI_TRIMMED_LINES - 2)| \
		sed 's/.//' | sed 's/.$//')"
	
	# Remove sidebars.
	#OUT="$(echo $OUT | cut -c 1-$LINE_CUTLEN)"
	#while IFS= read -r line ; do echo $line ; done <<< "$OUT"


	# Print result.
    echo "$OUT"
}   

# Run function.
nvidia-smi-trimmed-borderless
