{{- define "certmanager.rootCaName" -}}
{{ printf "%s-root" (include "cert-manager.fullname" .Subcharts.certmanager) | trunc 63 | trimSuffix "-"}}
{{- end -}}
