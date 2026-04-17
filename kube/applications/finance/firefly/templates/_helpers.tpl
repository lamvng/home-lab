{{- define "firefly.certificate" -}}
{{ printf "%s-certificate" (include "firefly-iii.fullname" $) | trunc 63 | trimSuffix "-" }}
{{- end -}}
