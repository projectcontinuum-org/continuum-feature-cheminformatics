{{/*
Expand the name of the chart.
*/}}
{{- define "continuum-feature-cheminformatics.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "continuum-feature-cheminformatics.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "continuum-feature-cheminformatics.labels" -}}
helm.sh/chart: {{ include "continuum-feature-cheminformatics.name" . }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: continuum
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "continuum-feature-cheminformatics.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Full label set for a resource, with global and per-service overrides layered
on top. Merge precedence (highest wins): extra > global.labels > component + base labels.
Usage: {{ include "continuum-feature-cheminformatics.componentLabels" (dict "context" $ "component" "feature-cheminformatics" "extra" .Values.continuum.featureCheminformatics.labels.deployment) | nindent 4 }}
*/}}
{{- define "continuum-feature-cheminformatics.componentLabels" -}}
{{- $result := dict -}}
{{- $result = mergeOverwrite $result (dict "app.kubernetes.io/component" .component) -}}
{{- $result = mergeOverwrite $result (include "continuum-feature-cheminformatics.labels" .context | fromYaml) -}}
{{- $result = mergeOverwrite $result (.context.Values.global.labels | default dict) -}}
{{- $result = mergeOverwrite $result (.extra | default dict) -}}
{{- toYaml $result -}}
{{- end }}

{{/*
Full annotation set for a resource, with global and per-service overrides
layered on top. Renders to nothing if there are no annotations to set.
Merge precedence (highest wins): extra > global.annotations.
Usage: {{- with (include "continuum-feature-cheminformatics.componentAnnotations" (dict "context" $ "extra" .Values.continuum.featureCheminformatics.annotations.deployment)) }}
annotations:
  {{- nindent 4 . }}
{{- end }}
*/}}
{{- define "continuum-feature-cheminformatics.componentAnnotations" -}}
{{- $result := dict -}}
{{- $result = mergeOverwrite $result (.context.Values.global.annotations | default dict) -}}
{{- $result = mergeOverwrite $result (.extra | default dict) -}}
{{- if $result -}}
{{ toYaml $result }}
{{- end -}}
{{- end }}

{{/* ======================== Infra service references ======================== */}}

{{- define "continuum-feature-cheminformatics.infra.temporal.address" -}}
{{- .Values.continuum.infra.temporal.host -}}:{{- .Values.continuum.infra.temporal.port -}}
{{- end }}

{{/* ======================== Secret names ======================== */}}

{{- define "continuum-feature-cheminformatics.minio.secretName" -}}
{{- if .Values.continuum.secrets.existingMinioSecret -}}
{{- .Values.continuum.secrets.existingMinioSecret -}}
{{- else -}}
{{- include "continuum-feature-cheminformatics.fullname" . -}}-minio-secret
{{- end -}}
{{- end }}
