#!/bin/bash
#====================================================================================================
# Baslik:           autodownload.sh
# Kullanim:         ./autodownload.sh
# Amaci:            Otomatik script guncelleme ve indirme.
# Sahibi:           Feridun OZTOK
# Versiyon:         1.2
# Tarih:            4 Ekim 2022
#====================================================================================================
#Degiskenler
#====================================================================================================
source /etc/profile.d/CP.sh
MEVCUTSURUM="Script Versiyon  : 1.2"
#====================================================================================================
#show_version_info Fonksiyon
#====================================================================================================
show_version_info() {
	echo ""
	echo "Script Versiyon  : 1.2"
	echo "Script Tarihi    : 4 Ekim 2022"
	echo "Son Guncelleyen  : Feridun OZTOK"
	echo ""
	exit 0
}
#====================================================================================================
#versiyon_kontrol Fonksiyon
#====================================================================================================
versiyon_kontrol() {
	sed '2,$d' surumyakala.txt >surumazalt.txt
	awk -F"MEVCUTSURUM=" '{print $2}' surumazalt.txt >surumkisa.txt
	sed 's/"//g' surumkisa.txt >surumtemizlenmis.txt
	GUNCELSURUM=$(<surumtemizlenmis.txt)
	rm surum*
	if [[ "$MEVCUTSURUM" == "$GUNCELSURUM" ]]; then
		echo "$MEVCUTSURUM" "Script calismaya uygun"
	else
		echo "Kullanilan surum guncel degil. Surumun $GUNCELSURUM olmasi gerekiyor."
		echo "./hardering.sh -u komutu ile guncelleyebilirsiniz. Script kapanacak."
		exit
	fi
}
#====================================================================================================
#show_help_infoFonksiyon
#====================================================================================================
show_help_info() {
	echo ""
	echo "Bu script, Feridun OZTOK tarafindan CheckPoint urunler uzerinde"
	echo "otomatik script indirme ve calistirma icin yazilmistir"
	echo "https://github.com/feroooo/ChecPoint-Auto-Download/tree/master"
	echo ""
	echo "Script SMS ve Gateway uzerinde calisabilmektedir."
	echo "Scriptin indirme islemi icin dosya ismi basinda auto- ya da host ismi olmasi gerekir."
	echo "Scriptin uzaktan calistirimasi icin sunucu uzerinde autorun.txt ye yazilmasi lazım."
	echo "Ozel bir cihaz icin calistirilacaksa $HOSTNAME-autorun.txt seklinde olmasi gerekir."
	echo ""
	echo "Script ./autodownload.sh seklinde calisir. Kullanilabilir diger parametreler -v -u -h 'dir"
	echo ""
	echo "./autodownload.sh -v ile mecvut scriptin surumunu ogrenebilirsiniz."
	echo "./autodownload.sh -u ile script surumunu guncelleyebilirsiniz."
	echo "./autodownload.sh -h ve diger tum tuslar su an okudugunuz yardim menusunu getirecektir."
	echo ""
	exit 0
}
#====================================================================================================
#download_updates Fonksiyon
#====================================================================================================
download_updates() {
	rm autodownload.sh
	curl_cli http://dynamic.egisbilisim.com.tr/script/autodownload.sh | cat >autodownload.sh && chmod 770 autodownload.sh
	exit 0
}
#====================================================================================================
#Fonksiyon Tuslari
#====================================================================================================
while getopts ":v :u :h" opt; do
	case "${opt}" in
	h)
		show_help_info
		;;
	u)
		download_updates
		;;
	v)
		show_version_info
		;;
	*)
		#Catch all for any other flags
		show_help_info
		exit 1
		;;
	esac
done
#====================================================================================================
#Temizlik ve Guncelleme
#====================================================================================================
#Her zaman egis.
cd /var/log/egis/
#Varsa eski dosyalari sil.
if [ -f autorun.txt ]; then
	rm autorun.txt
fi
#
if [ -f autodownloa*.txt ]; then
	rm autodownloa*.txt
fi
#
if [ -f $HOSTNAME-autorun.txt ]; then
	rm $HOSTNAME-autorun.txt
fi
#
if [ -f surumyakala.txt ]; then
	rm surumyakala.txt
fi
#Yeni listeyi al.
curl_cli http://dynamic.egisbilisim.com.tr/autorun/autorun.txt | cat >autorun.txt && chmod 770 autorun.txt
curl_cli http://dynamic.egisbilisim.com.tr/autorun/$HOSTNAME-autorun.txt | cat >$HOSTNAME-autorun.txt && chmod 770 $HOSTNAME-autorun.txt
curl_cli http://dynamic.egisbilisim.com.tr/autodownload/ >autodownload.txt
clear
#====================================================================================================
#Reklamlar
#====================================================================================================
echo
echo
echo *#######################################################*
echo *#__________ CheckPoint Auto Download Script _________##*
echo *#____________________ Version 1.2 ___________________##*
echo *#_____________ Creator by Feridun OZTOK _____________##*
echo *#_ Egis Proje ve Danismanlik Bilisim Hiz. Ltd. Sti. _##*
echo *#____________ support@egisbilisim.com.tr ____________##*
echo *#######################################################*
echo
echo
#====================================================================================================
#Esas Script
#====================================================================================================
#autodownload dosyasinin ici karisik ve bitisik nizam. Satir haline ceviriyor.
sed 's/"/\n/g' autodownload.txt >autodownload2.txt
#Gereksiz satirlar temizleniyor.
sed '/>/d' autodownload2.txt >autodownload3.txt
#Baslangicati 1ci ve 2ci satisi sil.
sed '1,2d' autodownload3.txt >autodownload4.txt
#Satir basindaki /autodownload/ kismini kaldir.
awk -F "/autodownload/" '{print $2}' autodownload4.txt >autodownload5.txt
#Satir sayisini say, degisken icine al.
SATIRSAYDownload=$(grep -o -i .sh autodownload5.txt | wc -l)
SATIRSAYRun=$(grep -o -i .sh autorun.txt | wc -l)
SATIRSAYHostRun=$(grep -o -i .sh $HOSTNAME-autorun.txt | wc -l)
#Varsa indirme islemi.
if [ $SATIRSAYDownload != 0 ]; then
	echo "Kaynakta dosya mevcut. Indirime islemi basliyor."
	AUTODOWNLOAD=autodownload5.txt
	while IFS= read -r INDIRILEN; do
		echo
		echo "**************************************************************************************"
		if [ -f $INDIRILEN ]; then
			rm $INDIRILEN
		fi
		if  [[ $INDIRILEN == auto-* ]] || [[ $INDIRILEN == $HOSTNAME-* ]] ; then
		echo "Indirilecek olan dosya: "$INDIRILEN
		curl_cli http://dynamic.egisbilisim.com.tr/autodownload/$INDIRILEN | cat >$INDIRILEN && chmod 770 $INDIRILEN
		fi
	done <"$AUTODOWNLOAD"
else
	echo "Kaynakta indirilecek dosya yok."
fi
#Varsa calistirma islemi.
if [ $SATIRSAYRun != 0 ]; then
	CALISTIR=$(cat autorun.txt)
	./$CALISTIR
fi
#Host ozel calistirma islemi
if [ $SATIRSAYHostRun != 0 ]; then
	CALISTIR=$(cat $HOSTNAME-autorun.txt)
	./$CALISTIR
fi
#Kalintilari sil.
rm autodownloa*.txt
rm autorun.txt
rm $HOSTNAME-autorun.txt
#Cik.
exit