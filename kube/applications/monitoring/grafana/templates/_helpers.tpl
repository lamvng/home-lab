{{- define "grafana.certificate" -}}
{{ printf "%s-certificate" (include "grafana.fullname" .Subcharts.grafana) | trunc 63 | trimSuffix "-"}}
{{- end -}}
