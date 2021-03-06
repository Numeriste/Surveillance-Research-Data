require 'curb'
require 'base64'
require 'pry'
require 'json'

index_name = "surveillance_research_archive"
default_dataspec = "ResearchReport"
detectors_to_run = [ {
                       annotator_name: "NamedEntityAnnotator",
                       input_params: {
                         fields_to_check: ["text", "description"],
                         type: "organization"},
                       output_param_names:{
                         catalyst_organizations: "catalyst_organizations"
                       }},
                     {
                       annotator_name: "TermlistAnnotator",
                       input_params: {
                         term_list: File.read("country_names.json"),
                         fields_to_check: ["text", "title"],
                         case_sensitive: false},
                       output_param_names:{
                         catalyst_termcategory: "catalyst_termcategory",
                         catalyst_termlist: "catalyst_countries"
                       }
                     },
                     {
                       annotator_name: "TermlistAnnotator",
                       input_params: {
                         term_list: File.read("topics.json"),
                         fields_to_check: ["text", "title"],
                         case_sensitive: false},
                       output_param_names:{
                         catalyst_termcategory: "catalyst_termcategory",
                         catalyst_termlist: "catalyst_topics"
                       }
                     },
                     {
                       annotator_name: "TermlistAnnotator",
                       input_params: {
                         term_list: File.read("tools.json"),
                         fields_to_check: ["text", "title"],
                         case_sensitive: false},
                       output_param_names:{
                         catalyst_termcategory: "catalyst_termcategory",
                         catalyst_termlist: "catalyst_tools"
                       }
                     },
                     {
                       annotator_name: "TermlistAnnotator",
                       input_params: {
                         term_list: File.read("company_names.json"),
                         fields_to_check: ["text", "title"],
                         case_sensitive: true},
                       output_param_names:{
                         catalyst_termcategory: "catalyst_termcategory",
                         catalyst_termlist: "catalyst_companies"
                       }
                     },
                     {
                       annotator_name: "LanguageAnnotator",
                       input_params: {
                         fields_to_check: ["text"]},
                       output_param_names:{
                         catalyst_language: "catalyst_language"
                       }
                     }
                     ]

docs_to_process = {
  run_over: "all"
}


   c = Curl::Easy.http_post("http://localhost:9004/annotate",
                            Curl::PostField.content('default_dataspec', default_dataspec),
                            Curl::PostField.content('index', index_name),
                            Curl::PostField.content('docs_to_process', JSON.generate(docs_to_process)),
                            Curl::PostField.content('input-params', JSON.generate(detectors_to_run)))

