library('tidyverse')

kuban_ids <- read_csv("data/pheno_varieties_ids_chern", col_names = FALSE)
lip_ids <- read_csv("data/pheno_varieties_ids_lip", col_names = FALSE)

kuba_sheets <- readxl::excel_sheets('data/kuba.xlsx')


kuba_df <- kuba_sheets %>% 
  map_dfr(
  ~{
    readxl::read_excel('data/kuba.xlsx', sheet = .x) %>% 
      mutate(observed = .x) %>% 
      mutate(across(everything(), as.character))
  }
    )

kuba_df %>% 
  pivot_longer(all_of(c('2020', '2021', '2022', '2023')), names_to = 'year', values_to = 'value') %>% View()

lip_sheets <- readxl::excel_sheets('data/lip.xlsx')


lip_df <- lip_sheets %>% 
  map_dfr(
    ~{
      readxl::read_excel('data/lip.xlsx', sheet = .x) %>% 
        mutate(observed = .x) %>% 
        mutate(across(everything(), as.character))
    }
  )

lip_df %>% 
  pivot_longer(all_of(c('2020', '2021', '2022', '2023')), names_to = 'year', values_to = 'value') %>% View()

kuba_df %>%
  filter(observed == "Тип роста") %>%  
  pull(`2020`) %>%                      
  unique()  

kuba_df <- kuba_df %>%
  mutate(`2020` = ifelse(observed == "Тип роста",
                         str_replace(`2020`, "индт\\.", "индт"),
                         `2020`))

kuba_df <- kuba_df %>%
  mutate(`2021` = ifelse(observed == "Тип роста" & `2021` == "Дт", "дт", `2021`))
