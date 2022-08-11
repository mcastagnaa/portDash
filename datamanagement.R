#AzureAuth::clean_token_directory()
#AzureGraph::delete_graph_login("maml.sharepoint.com")

# token <- AzureAuth::get_azure_token(tenant = "maml.sharepoint.com", 
#                                     resource = "https://maml.sharepoint.com/",
#                                     app = "8d83ba2140a51fde0b9da054f011d61a")

if(readline(prompt = "Connect to Sharepoint (Yes/anything)? ") == "Yes") {
  site <- tryCatch(get_sharepoint_site(site_id = "dc4edaeb-1257-40ab-8758-018b7b5bda5a"),
                   error = function(e) e)
  
  if(typeof(site)== "environment") {
    docs <- site$get_drive()
    
    ## dest <- tempfile("whatever.Rda")
    # docs$download_file("Stuff/DelSet.Rda", dest=dest)
    # load(dest)
    
    docs$download_file("Stuff/portDash.Rda", overwrite = T)
  }
}

pwd <- read.csv("pwd.csv") 

user_base <- tibble::tibble(
  user = pwd$user,
  password = sapply(pwd$password, sodium::password_store),
  permissions = pwd$permission,
  name = pwd$name
)

load("portDash.Rda")
dataTop <- dataTop %>%
  mutate(repDate = as.Date(repDate))

rm(docs, pwd, site)

commonFields <- c("TotalRiskPort", "TotalRiskBench", "TotalRiskDiff", "FactorContribDiff")

EqFields <- c("DivYldPort", "DivYldBench", "PEPort", "PEBench",
              "PBPort", "PBBench")
FIFields <- c("LocalYieldPort", "LocalYieldBench", "OADPort", "OADBench", "LOASPort", "LOASBench")


