#!/bin/bash
#====================================================================================================
# Baslik:           autodownload.sh
# Kullanim:         ./autodownload.sh
# Amaci:            Otomatik script guncelleme ve indirme.
# Sahibi:           Feridun OZTOK
# Versiyon:         1.0
# Tarih:            29 Agustos 2022
#====================================================================================================

#====================================================================================================
# Degiskenler
#====================================================================================================
source /etc/profile.d/CP.sh

#Her zaman egis.
cd /var/log/egis/
#Varsa eski dosyalari sil.
if [ -f autorun.txt ]
then
rm autorun.txt
fi
#
if [ -f autodownloa*.txt ]
then
rm autodownloa*.txt
fi
#Yeni listeyi al.
curl_cli http://dynamic.egisbilisim.com.tr/autodownload/autorun.txt | cat > autorun.txt && chmod 770 autorun.txt
curl_cli http://dynamic.egisbilisim.com.tr/autodownload/ > autodownload.txt
#Ekrani temizle.
clear
#Satir haline cevir.
sed 's/"/\n/g' autodownload.txt > autodownload2.txt
#Gerekis satirlari temzile.
sed '/>/d' autodownload2.txt > autodownload3.txt
#Baslangicati 1ci ve 2ci satisi sil.
sed '1,2d' autodownload3.txt > autodownload4.txt
#autorun.txt yi kaldir.
sed '/autorun.txt/d' autodownload4.txt > autodownload5.txt
#Satir basindaki /autodownload/ kismini kaldir.
awk -F "/autodownload/"  '{print $2}' autodownload5.txt > autodownload6.txt
#Satir sayisini say, degisken icine al.
SATIRSAYDownload=`grep -o -i .sh autodownload6.txt | wc -l`
SATIRSAYRun=`grep -o -i .sh autorun.txt | wc -l`
#Varsa indirme islemi.
if [ $SATIRSAYDownload != 0  ]
then
	echo "Kaynakta dosya mevcut. Indirime islemi basliyor."
	AUTODOWNLOAD=autodownload6.txt
		while IFS= read -r INDIRILEN
		do
		echo
		echo "**************************************************************************************"
		echo "Indirilecek olan dosya: "$INDIRILEN
			if [ -f $INDIRILEN  ]
			then
			rm $INDIRILEN 
			fi
		curl_cli http://dynamic.egisbilisim.com.tr/script/$INDIRILEN | cat > $INDIRILEN && chmod 770 $INDIRILEN
		done < "$AUTODOWNLOAD"
else
  echo "Kaynakta indirilecek dosya yok."
fi
#Varsa calistirma islemi.
if [ $SATIRSAYRun != 0  ]
then
CALISTIR=`cat autorun.txt`
./$CALISTIR
fi
#Kalintilari sil.
rm autodownloa*.txt
rm autorun.txt
#Cik.
exit