{{- define "my-chart.name" -}}
{{ printf "%s-%s" .Chart.Name .Values.fullName  | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "my-chart.default.name" -}}
{{ default .default .name  }}
{{- end }}


{{- define "my-chart.configmap.name" -}}
{{ printf "%s-%s-configmap" (include "my-chart.name" .Values.configmap ) .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "my-chart.storageclass.name" -}}
{{ printf "%s-%s" (include "my-chart.name" .Values.storageClass ) .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "my-chart.pvc.name" -}}
{{ printf "%s-%s" (include "my-chart.name" .Values.persistentVolumeClaim ) .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "my-chart.labels" -}}
app: {{ include "my-chart.name" . }}
{{- end }}