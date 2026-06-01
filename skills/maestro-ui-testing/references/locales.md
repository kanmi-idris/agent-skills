# Locale Reference

Use this reference when creating or running localization flows.

## Runtime Rules

Locale is a device-level setting. Set it before running flows:

```bash
maestro start-device --platform android --device-locale fr_FR
maestro test .maestro/
```

or for iOS:

```bash
maestro start-device --platform ios --device-locale it_IT
maestro test .maestro/
```

Important rules:

- Use `--device-locale` with `maestro start-device` and `maestro cloud`.
- Do not use `--device-locale` with `maestro test`; it is not supported there.
- Do not define locale inside a flow, `launchApp`, or `config.yaml`.
- Locale values are usually ISO-639-1 language plus ISO-3166-1 country separated by `_`, such as `fr_FR`.
- Maestro attempts to change system language and region on the simulator or emulator before the flow runs.
- Web tests do not control Chrome's internal language settings.

## Locale Tags

Tag locale-specific tests and run only the relevant set.

```yaml
appId: com.example.app
tags:
  - french
---
- launchApp
- assertVisible: "Bienvenue"
```

```bash
maestro start-device --platform android --device-locale fr_FR
maestro test --include-tags french .maestro/
```

## Android Supported Country/Region Codes

Android can typically use a language code or a language-country pair such as `pt-BR`.

| Code | Name |
| --- | --- |
| AU | Australia |
| AT | Austria |
| BE | Belgium |
| BR | Brazil |
| GB | Britain |
| BG | Bulgaria |
| CA | Canada |
| HR | Croatia |
| CZ | Czech Republic |
| DK | Denmark |
| EG | Egypt |
| FI | Finland |
| FR | France |
| DE | Germany |
| GR | Greece |
| HK | Hong Kong |
| HU | Hungary |
| IN | India |
| ID | Indonesia |
| IE | Ireland |
| IL | Israel |
| IT | Italy |
| JP | Japan |
| KR | Korea |
| LV | Latvia |
| LI | Liechtenstein |
| LT | Lithuania |
| NL | Netherlands |
| NZ | New Zealand |
| NO | Norway |
| PH | Philippines |
| PL | Poland |
| PT | Portugal |
| CN | PRC |
| RO | Romania |
| RU | Russia |
| RS | Serbia |
| SG | Singapore |
| SK | Slovakia |
| SI | Slovenia |
| ES | Spain |
| SE | Sweden |
| CH | Switzerland |
| TW | Taiwan |
| TH | Thailand |
| TR | Turkey |
| UA | Ukraine |
| US | USA |
| VN | Vietnam |
| ZA | Zimbabwe |

## iOS Supported Locale Examples

| Locale | Name |
| --- | --- |
| `en_AU` | Australia (English) |
| `nl_BE` | Belgium (Dutch) |
| `fr_BE` | Belgium (French) |
| `pt-BR` | Brazil (Portuguese) |
| `ms_BN` | Brunei Darussalam |
| `zh_CN` | China (Simplified) |
| `zh-Hans` | China (Simplified) |
| `zh-Hant` | China (Traditional) |
| `en_CA` | Canada (English) |
| `fr_CA` | Canada (French) |
| `cs_CZ` | Czech Republic |
| `fi_FI` | Finland |
| `fr_FR` | France |
| `de_DE` | Germany |
| `el_GR` | Greece |
| `zh_HK` | Hong Kong |
| `hu_HU` | Hungary |
| `hi_IN` | India (Hindi) |
| `en-IN` | India (English) |
| `id_ID` | Indonesia |
| `en-IE` | Ireland |
| `he_IL` | Israel |
| `it_IT` | Italy |
| `ja_JP` | Japan |
| `ko_KR` | Korea |
| `es-419` | Latin America (Spanish) |
| `ms_MY` | Malaysia |
| `es-MX` | Mexico (Spanish) |
| `nl_NL` | Netherlands |
| `en_NZ` | New Zealand |
| `nb_NO` | Norway |
| `tl_PH` | Philippines |
| `pl_PL` | Poland |
| `ro_RO` | Romania |
| `ru_RU` | Russia |
| `en_SG` | Singapore |
| `sk_SK` | Slovakia |
| `en-ZA` | South Africa (English) |
| `es_ES` | Spain |
| `sv_SE` | Sweden |
| `zh_TW` | Taiwan |
| `th_TH` | Thailand |
| `tr_TR` | Turkey |
| `uk_UA` | Ukraine |
| `en_GB` | UK (English) |
| `es_US` | USA (Spanish) |
| `en_US` | USA (English) |
| `vi_VN` | Vietnam |
