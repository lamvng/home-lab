{{- define "ollama.certificate" -}}
{{ printf "%s-certificate" (include "ollama.fullname" .Subcharts.ollama) | trunc 63 | trimSuffix "-"}}
{{- end -}}
