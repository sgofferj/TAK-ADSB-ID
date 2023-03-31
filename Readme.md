# TAK ADSB ID collection

[![Aircraft count](https://img.shields.io/static/v1?label=Aircraft&message=1943&color=2ea44f)](https://github.com/sgofferj/TAK-ADSB-ID)
## Overview
This is a collection of specific ICAO hexids to make ATAK/WinTAK SA displays more meaningful. The idea is to use them in the middleware which feeds ADSB data as CoT objects into a TAK server.
I started out with Finland but pull requests are welcome.
## Civilian or military?
I use mostly the definitions of the country. In Finland, e.g. the Border Guard is considered not a military branch but a law enforcement agency under the Ministry of the Interior. Hence, at the moment, I classify FBG aircraft as "a-f-A-C-\*". 
## Friendly, hostile, neutral?
I classify the aircraft from the point of view of somebody living in Finland. Finland is not at war with anybody at this point in time, so at the moment I do not classify any aircraft as hostile. If you feel, some aircraft should be classified as hostile, please download the files and use the search and replace function on your local copy.
Civilian aircraft I generally classify as neutral unless they are somehow special, such as law enforcement of a friendly (or non-friendly) country or EMS aircraft.

**Update 2022-04-26:** Due to the Ukraine conflict and the changes in Finnish foreign policy, I reclassified all Russian planes as "hostile".

## Other stuff
To assist middlewares with displaying special civilian aircraft, I am developing some conventions for the source files:
- EMS aircraft will have their operator field in the format "EMS (operator)".
- SAR aircraft will have their operator field in the format "SAR (operator)".
- Law enforcement aircraft will have their operator field in the format "LEO (operator)".
## json
Since release 162458ZFEB23 the releases also contain a json file (cotdb.json) which should make integration of the data in 3rd party middleware fairly easy. The format is:
```json
{
  "aircraft": [
    {
      "hexid": "3dd55c",
      "cot": "a-n-A-C-H",
      "reg": "D-HBAY",
      "type": "BK117B2",
      "operator": "EMS (ADAC)"
    },
    { ... }
  ]
}
```
The second available JSON format (cotdb_indexed.json) is
```json
{
  "3dd55c":["a-n-A-C-H","D-HBAY","BK117B2","EMS (ADAC)"],
  "3dd652":["a-n-A-C-H","D-HBKK","BK117B2","EMS (ADAC)"]
}

```
## Contributing
Please feel free to contribute to the list! Ideally, you would submit a pull request, but you can also open an issue. Please keep in mind what I wrote above under "Friendly, hostile, neutral?".
## Issues
I will try to handle issues fast but this is a hobby, I have a family and a busy work day, so please don't expect wonders!
## License
This repo is published under the Creative Commons Attribution-ShareAlike 4.0 International License.
