#! /bin/bash

export OUTPUTDIR="$(pwd)/result"
export UDPSIZES="$1"
export ALGS="$2"
export BUILDDIR="$(pwd)/build"
export WORKINGDIR="$(pwd)"
mkdir -p $OUTPUTDIR
for ALG in $ALGS
do
	echo $ALG
	for UDPSIZE in $UDPSIZES
	do
		cd $WORKINGDIR
		echo $UDPSIZE
		if [[ $UDPSIZE == "notcp" ]]
		then
			python3 build_docker_compose.py --bypass --maxudp 1232 --alg $ALG <<< "Y"
		else
			if [[ $UDPSIZE == "stock" ]]
			then
				python3 build_docker_compose.py --bypass --maxudp 1232 --alg $ALG <<< "Y"
				cp resolver/named_stock.conf build/resolver/named.conf
			else
				python3 build_docker_compose.py --maxudp $UDPSIZE --alg $ALG <<< "Y"
			fi
		fi
		cd $BUILDDIR
		docker compose down
		docker compose build
		cd $WORKINGDIR
		if [[ $ALG == SPHINCS+-SHA256-128S ]]
		then
			echo "Being safe..."
			cp tmux-run-docker-part2_sphincs+_safe.bash build/tmux-run-docker-part2.bash
		fi
		if [[ $ALG == DILITHIUM2 ]]
		then
			if [[ $UDPSIZE -eq 256 ]]
			then
				echo "Being safe..."
				cp tmux-run-docker-part2_dilithium2_safe.bash build/tmux-run-docker-part2.bash
			fi
		fi

		./run_exps.bash 0 100 | tee scratch.log
		echo "$ALG"_"$UDPSIZE"": " $(tail -n 1 scratch.log) >> results_summary.log
		rm scratch.log
		cd $BUILDDIR/dig_logs
		tar -cvf "X86_64_""$ALG"_"$UDPSIZE"".tar" * > /dev/null 2>&1
		mv  "X86_64_""$ALG"_"$UDPSIZE"".tar" $OUTPUTDIR
	done
done
