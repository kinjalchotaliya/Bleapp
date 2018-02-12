json.status          "Success"
json.message         "List of Highlights"
json.data @highlights do |highlight|
  json.id                      highlight.id
  json.title                   highlight.title
  json.note                    highlight.note
  json.image                   highlight.image
end