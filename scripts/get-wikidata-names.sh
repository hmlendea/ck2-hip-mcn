#!/bin/bash

WIKIDATA_ID="${1}"
WIKIDATA_URL="https://www.wikidata.org/wiki/Special:EntityData/${1}.json"

if [ ! -f "/usr/bin/jq" ]; then
    echo "Missing 'jq'! Please make sure it's present on the system in order to use this script!"
    exit 1
fi

DATA=$(curl -s "${WIKIDATA_URL}")

function normalise-name() {
    echo $* | \
        sed 's/^"\(.*\)"$/\1/g' | \
        awk -F" - " '{print $1}' | \
        awk -F"/" '{print $1}' | \
        awk -F"(" '{print $1}' | \
        awk -F"," '{print $1}' | \
        sed 's/ *$//g' | \
        sed 's/ \(suyu\|[Mm]unicipality\)$//g' | \
        sed 's/^\([Gg]e*m[ei]n*t*[aen]\) //g' | \
        sed 's/ [KkCc]om*un*[ea]*$//g' | \
        sed 's/^[KkCc]om*un*[ea] d[eio] //g' | \
        sed 's/^Lungsod ng //g'
}

function capitalise() {
    printf '%s' "$1" | head -c 1 | tr [:lower:] [:upper:]
    printf '%s' "$1" | tail -c '+2'
}

function get-raw-name-for-language() {
    LANGUAGE_CODE="${1}"
    RAW_NAME=$(echo "${DATA}" | jq '.entities.'${WIKIDATA_ID}'.labels.'"\""${LANGUAGE_CODE}"\""'.value')
    NORMALISED_NAME=$(normalise-name "${RAW_NAME}")

    if [ "${NORMALISED_NAME}" != "null" ]; then
        if [ "${LANGUAGE_CODE}" == "jbo" ] ; then
            NORMALISED_NAME=$(capitalise "${NORMALISED_NAME}")
        fi
    fi

    echo "${NORMALISED_NAME}"
}

ENGLISH_NAME=$(get-raw-name-for-language "en")

function get-name-for-language() {
    LANGUAGE_ID="${1}"
    LANGUAGE_CODE="${2}"
    NAME=$(get-raw-name-for-language "${LANGUAGE_CODE}")

    if [ -z "${NAME}" ] ||  [ "${NAME}" == "null" ]; then
        return
    fi

    NAME_FOR_COMPARISON=$(echo "${NAME}" | tr '[:upper:]' '[:lower:]')
    ENGLISH_NAME_FOR_COMPARISON=$(echo "${ENGLISH_NAME}" | tr '[:upper:]' '[:lower:]')

    if [ "${LANGUAGE_CODE}" != "en" ] && [ "${NAME_FOR_COMPARISON}" == "${ENGLISH_NAME_FOR_COMPARISON}" ]; then
        return
    fi

    echo "      <Name language=\"${LANGUAGE_ID}\" value=\"${NAME}\" />"
}

function get-name-for-language-2variants() {
    LANGUAGE1_ID="${1}"
    LANGUAGE1_CODE="${2}"
    LANGUAGE2_ID="${3}"
    LANGUAGE2_CODE="${4}"

    LANGUAGE1_NAME=$(get-raw-name-for-language "${LANGUAGE1_CODE}")
    LANGUAGE2_NAME=$(get-raw-name-for-language "${LANGUAGE2_CODE}")

    if [ -n "${LANGUAGE1_NAME}" ] && [ "${LANGUAGE2_NAME}" != "${LANGUAGE1_NAME}" ]; then
        get-name-for-language "${LANGUAGE1_ID}" "${LANGUAGE1_CODE}"
    fi

    get-name-for-language "${LANGUAGE2_ID}" "${LANGUAGE2_CODE}"
}

function get-names() {
    get-name-for-language "Acehnese" "ace"
    get-name-for-language "Afrikaans" "af"
    get-name-for-language "Akan_Twi" "tw"
    get-name-for-language "Akan" "ak"
    get-name-for-language "Albanian" "sq"
    get-name-for-language "Alemannic" "gsw"
    get-name-for-language "Aragonese" "an"
    get-name-for-language "Aromanian" "rup"
    get-name-for-language "Arpitan" "frp"
    get-name-for-language "Asturian" "ast"
    get-name-for-language "Atayal" "tay"
    get-name-for-language "Atikamekw" "atj"
    get-name-for-language "Aymara" "ay"
    get-name-for-language "Azeri" "az"
    get-name-for-language "Balinese" "ban"
    get-name-for-language "Bambara" "bm"
    get-name-for-language "Banjarese" "bjn"
    get-name-for-language "Basque" "eu"
    get-name-for-language "Bavarian" "bar"
    get-name-for-language "Bikol_Central" "bcl"
    get-name-for-language "Bislama" "bi"
    get-name-for-language "Breton" "br"
    get-name-for-language "Buginese" "bug"
    get-name-for-language "Catalan" "ca"
    get-name-for-language "Cebuano" "ceb"
    get-name-for-language "Chamorro" "ch"
    get-name-for-language "Chewa" "ny"
    get-name-for-language "Cheyenne" "chy"
    get-name-for-language "Chinese_Hakka" "hak"
    get-name-for-language "Chinese_Min_Eastern" "cdo"
    get-name-for-language "Chinese_Min_South" "nan"
    get-name-for-language "Cornish" "kw"
    get-name-for-language "Corsican" "co"
    get-name-for-language "Czech" "cs"
    get-name-for-language "Danish" "da"
    get-name-for-language "Dinka" "din"
    get-name-for-language "Dutch" "nl"
    get-name-for-language "Emilian_Romagnol" "eml"
    get-name-for-language "English_Old" "ang"
    get-name-for-language "English" "en"
    get-name-for-language "Esperanto" "eo"
    get-name-for-language "Estonian" "et"
    get-name-for-language "Ewe" "ee"
    get-name-for-language "Extremaduran" "ext"
    get-name-for-language "Faroese" "fo"
    get-name-for-language "Fijian" "fj"
    get-name-for-language "Fijian_Hindi" "hif"
    get-name-for-language "Finnish" "fi"
    get-name-for-language "Flemish_West" "vls"
    get-name-for-language "French" "fr"
    get-name-for-language "Frisian_North" "frr"
    get-name-for-language "Frisian_Saterland" "stq"
    get-name-for-language "Frisian_West" "fy"
    get-name-for-language "Friulian" "fur"
    get-name-for-language "Fulah" "ff"
    get-name-for-language "Gagauz" "gag"
    get-name-for-language "Galician" "gl"
    get-name-for-language "German_Low_Dutch" "nds-nl"
    get-name-for-language "German_Low" "nds"
    get-name-for-language "German_Palatine" "pfl"
    get-name-for-language "German_Pennsylvania" "pdc"
    get-name-for-language "German" "de"
    get-name-for-language "Greenlandic" "kl"
    get-name-for-language "Guarani" "gn"
    get-name-for-language "Guianese_French" "gcr"
    get-name-for-language "Haitian" "ht"
    get-name-for-language "Hausa" "ha"
    get-name-for-language "Hawaiian" "haw"
    get-name-for-language "Hungarian" "hu"
    get-name-for-language "Icelandic" "is"
    get-name-for-language "Ido" "io"
    get-name-for-language "Igbo" "ig"
    get-name-for-language "Ilocano" "ilo"
    get-name-for-language "Indonesian" "id"
    get-name-for-language "Interlingua" "ia"
    get-name-for-language "Interlingue" "ie"
    get-name-for-language "Irish" "ga"
    get-name-for-language "Italian" "it"
    get-name-for-language "Jamaican" "jam"
    get-name-for-language "Javanese" "jv"
    #get-name-for-language "Kabiye" "kbp"
    get-name-for-language "Kabyle" "kab"
    get-name-for-language "Kapampangan" "pam"
    get-name-for-language "Karakalpak" "kaa"
    get-name-for-language "Kashubian" "csb"
    get-name-for-language "Kazakh" "kk-latn"
    get-name-for-language "Kichwa_Chimboraazo" "qug"
    get-name-for-language "Kikuyu" "ki"
    get-name-for-language "Kinyarwanda" "rw"
    get-name-for-language "Kongo" "kg"
    get-name-for-language "Konkani_Goa" "gom-latn"
    get-name-for-language "Kotava" "avk"
    get-name-for-language "Kurdish" "ku"
    get-name-for-language "Ladin" "lld"
    get-name-for-language "Ladino" "lad"
    get-name-for-language "Latgalian" "ltg"
    get-name-for-language "Latin" "la"
    get-name-for-language "Latvian" "lv"
    get-name-for-language "Ligurian" "lij"
    get-name-for-language "Limburgish" "li"
    get-name-for-language "Lingala" "ln"
    get-name-for-language "Lingua_Franca_Nova" "lfn"
    get-name-for-language "Lithuanian" "lt"
    get-name-for-language "Livvi" "olo"
    get-name-for-language "Lojban" "jbo"
    get-name-for-language "Lombard" "lmo"
    get-name-for-language "Luganda" "lg"
    get-name-for-language "Luxembourgish" "lb"
    get-name-for-language "Madurese" "mad"
    get-name-for-language "Malagasy" "mg"
    get-name-for-language "Malay" "ms"
    get-name-for-language "Maltese" "mt"
    get-name-for-language "Manx" "gv"
    get-name-for-language "Maori" "mi"
    get-name-for-language "Minangkabau" "min"
    get-name-for-language "Mirandese" "mwl"
    get-name-for-language "Nahuatl" "nah"
    get-name-for-language "Nauru" "na"
    get-name-for-language "Neapolitan" "nap"
    get-name-for-language "Norman" "nrm"
    get-name-for-language-2variants "Norwegian_Nynorsk" "nn" "Norwegian" "nb"
    get-name-for-language "Novial" "nov"
    get-name-for-language "Occitan" "oc"
    get-name-for-language "Oromo" "om"
    get-name-for-language "Pangasinan" "pag"
    get-name-for-language "Papiamento" "pap"
    get-name-for-language "Picard" "pcd"
    get-name-for-language "Piemontese" "pms"
    get-name-for-language "Pitkern" "pih"
    get-name-for-language "Plautdietsch" "pdt"
    get-name-for-language "Polish" "pl"
    get-name-for-language-2variants "Portuguese_Brazilian" "pt-br" "Portuguese" "pt"
    get-name-for-language "Quechua" "qu"
    get-name-for-language "Romani_Vlax" "rmy"
    get-name-for-language "Romanian" "ro"
    get-name-for-language "Romansh" "rm"
    get-name-for-language "Rundi" "rn"
    get-name-for-language "Sakizaya" "szy"
    get-name-for-language "Sami_Inari" "smn"
    get-name-for-language "Sami_North" "se"
    get-name-for-language "Sami_Skolt" "sms"
    get-name-for-language "Sami_South" "sma"
    get-name-for-language "Samoan" "sm"
    get-name-for-language "Samogitian" "sgs"
    get-name-for-language "Sango" "sg"
    get-name-for-language "Sardinian" "sc"
    get-name-for-language "Scots" "sco"
    get-name-for-language "Scottish_Gaelic" "gd"
    get-name-for-language "Seediq" "trv"
    get-name-for-language-2variants "Bosnian" "bs" "SerboCroatian" "sh"
    get-name-for-language-2variants "Croatian" "hr" "SerboCroatian" "sh"
    get-name-for-language-2variants "Serbian" "sr-el" "SerboCroatian" "sh"
    get-name-for-language "Shona" "sn"
    get-name-for-language "Sicilian" "scn"
    get-name-for-language "Silesian" "szl"
    get-name-for-language "Slovak" "sk"
    get-name-for-language "Slovene" "sl"
    get-name-for-language "Somali" "so"
    get-name-for-language "Sorbian_Lower" "dsb"
    get-name-for-language "Sorbian_Upper" "hsb"
    get-name-for-language "Spanish" "es"
    get-name-for-language "Sundanese" "su"
    get-name-for-language "Surinamese" "srn"
    get-name-for-language "Swahili" "sw"
    get-name-for-language "Swazi" "ss"
    get-name-for-language "Swedish" "sv"
    get-name-for-language "Tagalog" "tl"
    get-name-for-language "Tahitian" "ty"
    get-name-for-language "Tajiki" "tg-latn"
    get-name-for-language "Tarantino" "roa-tara"
    get-name-for-language "Tatar_Crimean" "crh-latn"
    get-name-for-language "Tetum" "tet"
    get-name-for-language "Tok_Pisin" "tpi"
    get-name-for-language "Tsonga" "ts"
    get-name-for-language "Turkish" "tr"
    get-name-for-language "Turkmen" "tk"
    get-name-for-language "Uzbek" "uz"
    get-name-for-language "Venetian" "vec"
    get-name-for-language "Vepsian" "vep"
    get-name-for-language "Vietnamese" "vi"
    get-name-for-language "Volapuk" "vo"
    get-name-for-language "Voro" "vro"
    get-name-for-language "Walloon" "wa"
    get-name-for-language "Waray" "war"
    get-name-for-language "Welsh" "cy"
    get-name-for-language "Wolof" "wo"
    get-name-for-language "Xhosa" "xh"
    get-name-for-language "Yoruba" "yo"
    get-name-for-language "Zazaki_Dimli" "diq"
    get-name-for-language "Zeelandic" "zea"
    get-name-for-language "Zhuang" "za"
    get-name-for-language "Zulu" "zu"
}

function get-location-entry() {
    NAMES="$(get-names)"

    [ -z "${NAMES}" ] && return

    LOCATION_ID=$(echo "${ENGLISH_NAME}" | \
        tr '[:upper:]' '[:lower:]' | \
        sed 's/-le-/_le_/g' | \
        sed 's/ /_/g' | sed "s/\'//g" | \
        sed 's/\(north\|west\|south\|east\)ern/\1/g' | \
        sed 's/^\(north\|west\|south\|east\)_\(.*\)$/\2_\1/g' | \
        iconv -f utf8 -t ascii//TRANSLIT)

    echo "  <LocationEntity>"
    echo "    <Id>${LOCATION_ID}</Id>"
    echo "    <WikidataId>${WIKIDATA_ID}</WikidataId>"
    echo "    <GameIds>"
    echo "    </GameIds>"
    echo "    <Names>"
    get-names | sort | uniq
    echo "    </Names>"
    echo "  </LocationEntity>"
}

echo ""
get-location-entry