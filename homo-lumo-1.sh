#!/bin/bash
# band-gap for spin polarized calculation by Mihir
#this script extract data from EIGENVAL file and calculate band-gap
###########################################
#this  script is only for spin polarized calcualtion, when ISPIN = 2 in INCAR
# put the script in the directory where band-structure  calculation is done
#run rhe script by typing ./script_name.sh
# Any doubt regarding script, freely caontact me through following mail ids.
#		mrs10@iitbbs.ac.in
#		smihirranjan@gmail.com
###########################################
homo=$(sed -n 6p EIGENVAL|awk '{ print ("%\n",($1/2)); }')
echo "band number occupird by HOMO =" $homo
lumo=$(sed -n 6p EIGENVAL|awk '{ print ("%\n",($1/2+1)); }')
echo "band number occupied by LUMO =" $lumo
nkpt=$(sed -n 6p EIGENVAL|awk '{ printf("%d\n", ($2)); }')
echo "number of KPOINTS=" $nkpt
#c=$(grep  E-fermi  OUTCAR|awk '{ print ("\n", ($3)); }')
#echo $c
e1=$(grep "     $homo     " $1 EIGENVAL | sort -n -k 2 | tail -1 | awk '{printf ("%f\n" ,($2)); }')
e2=$(grep "     $lumo     " $1 EIGENVAL | sort -n -k 2 | head -1 | awk '{printf ("%f\n" ,($2)); }')
echo "HOMO: band for spi-up" $homo " E=" $e1
echo "LUMO: band for spin-up" $lumo " E=" $e2
if (( $(echo "$e2 > $e1" |bc) )); then
echo "band gap for spin up exists"
band_gap_up=$(echo "$e2 - $e1"|bc)
echo " bandgap for spin-up = " $band_gap_up
else 
echo "system is metallic for spin-up"
fi ;
e3=$(grep "     $homo     " $1 EIGENVAL | sort -n -k 2 | tail -1 | awk '{printf ("%f\n" ,($3)); }')
e4=$(grep "     $lumo     " $1 EIGENVAL | sort -n -k 2 | head -1 | awk '{printf ("%f\n" ,($3)); }')
echo "HOMO: band for spin-down:" $homo " E=" $e3
echo "LUMO: band for spin-down" $lumo " E=" $e4
if (( $(echo "$e4 > $e3" |bc) )); then
echo "band gap  for spin down exists"
band_gap_down=$(echo "$e4 - $e3"|bc)
echo " bandgap for spin-down = " $band_gap_down
else 
echo "system is metallic for spin-down"
fi ;
