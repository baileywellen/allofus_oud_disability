library(tidyverse)
library(bigrquery)

# This query represents dataset "disability_carecascade" for domain "drug" and was generated for All of Us Registered Tier Dataset v8
dataset_34437487_drug_sql <- paste("
    SELECT
        d_exposure.person_id,
        d_exposure.drug_concept_id,
        d_standard_concept.concept_name as standard_concept_name,
        d_standard_concept.concept_code as standard_concept_code,
        d_standard_concept.vocabulary_id as standard_vocabulary,
        d_exposure.drug_exposure_start_datetime,
        d_exposure.drug_exposure_end_datetime,
        d_exposure.verbatim_end_date,
        d_exposure.drug_type_concept_id,
        d_type.concept_name as drug_type_concept_name,
        d_exposure.stop_reason,
        d_exposure.refills,
        d_exposure.quantity,
        d_exposure.days_supply,
        d_exposure.sig,
        d_exposure.route_concept_id,
        d_route.concept_name as route_concept_name,
        d_exposure.lot_number,
        d_exposure.visit_occurrence_id,
        d_visit.concept_name as visit_occurrence_concept_name,
        d_exposure.drug_source_value,
        d_exposure.drug_source_concept_id,
        d_source_concept.concept_name as source_concept_name,
        d_source_concept.concept_code as source_concept_code,
        d_source_concept.vocabulary_id as source_vocabulary,
        d_exposure.route_source_value,
        d_exposure.dose_unit_source_value 
    FROM
        ( SELECT
            * 
        FROM
            `drug_exposure` d_exposure 
        WHERE
            (
                drug_concept_id IN (SELECT
                    DISTINCT ca.descendant_id 
                FROM
                    `cb_criteria_ancestor` ca 
                JOIN
                    (SELECT
                        DISTINCT c.concept_id       
                    FROM
                        `cb_criteria` c       
                    JOIN
                        (SELECT
                            CAST(cr.id as string) AS id             
                        FROM
                            `cb_criteria` cr             
                        WHERE
                            concept_id IN (1103640, 1133201, 1714319, 21604254)             
                            AND full_text LIKE '%_rank1]%'       ) a 
                            ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                            OR c.path LIKE CONCAT('%.', a.id) 
                            OR c.path LIKE CONCAT(a.id, '.%') 
                            OR c.path = a.id) 
                    WHERE
                        is_standard = 1 
                        AND is_selectable = 1) b 
                        ON (ca.ancestor_id = b.concept_id)))  
                    AND (d_exposure.PERSON_ID IN (SELECT
                        distinct person_id  
                FROM
                    `cb_search_person` cb_search_person  
                WHERE
                    cb_search_person.person_id IN (SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN(SELECT
                                DISTINCT c.concept_id 
                            FROM
                                `cb_criteria` c 
                            JOIN
                                (SELECT
                                    CAST(cr.id as string) AS id       
                                FROM
                                    `cb_criteria` cr       
                                WHERE
                                    concept_id IN (44819543, 1568415, 35207238, 44827678, 1569071, 35225282, 1576172, 44832361, 45563315, 44828872, 1576239, 44827366, 44822999, 44837827, 1569075, 1576311, 1568407, 44823473, 44824618, 1568908, 35207243, 1568408, 44823020, 35207242, 44833491, 1576291, 44823838, 35207240, 44828852, 1568262, 1568412, 35207239, 44833401, 35207241)       
                                    AND full_text LIKE '%_rank1]%'      ) a 
                                    ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                                    OR c.path LIKE CONCAT('%.', a.id) 
                                    OR c.path LIKE CONCAT(a.id, '.%') 
                                    OR c.path = a.id) 
                            WHERE
                                is_standard = 0 
                                AND is_selectable = 1) 
                            AND is_standard = 0 )) criteria 
                    UNION
                    DISTINCT SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN (927179, 927186, 927180, 2314299, 927182, 927181, 927183, 2314297, 2314312, 927184) 
                            AND is_standard = 0 )) criteria 
                    UNION
                    DISTINCT SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN (2720162, 2720060, 2720074, 2720152, 2720359, 2720313, 2720427, 2720381, 2720479, 40660167, 2719999, 2719992, 44786598, 2720063, 2720141, 2720455, 2719976, 2720086, 40662114, 44786597, 2720369, 2720466, 2720123, 44782259, 2720422, 2720091, 2720383, 2616864, 2720138, 2720434, 2720257, 2720481, 2720259, 2720456, 2720164, 2720169, 2720096, 2720005, 2720024, 44782268, 2720217, 2720450, 2720044, 2720432, 2720136, 2720392, 2720127, 2719988, 2720436, 2720049, 2720046, 2720425, 2720470, 44782254, 2719971, 44782262, 44782255, 2720124, 2720438, 43533236, 2720131, 2720082, 40217612, 2720135, 2720065, 2720331, 2720476, 2720236, 2720458, 2720089, 2720027, 2720448, 2720417, 2720443, 43533220, 2720094, 2720382, 2720480, 2720137, 2720413, 2720154, 2720462, 2720110, 2720026, 44782253, 44782258, 2720230, 2720168, 40664531, 2720461, 2616774, 2720232, 953198, 2720156, 2720379, 2720358, 2720143, 937587, 2720431, 2720449, 44782264, 2720075, 2720223, 2720467, 915813,
 2720447, 2720031, 40662117, 2720035, 2720395, 2719973, 2720429, 2720416, 2720370, 2720368, 2720414, 2720023, 2720384, 2720095, 2720442, 2720474, 2720377, 2720482, 2720158, 2719980, 2720052, 2720231, 2720468, 2720233, 2720151, 2720386, 2720419, 2720256, 2720248, 2720018, 2720314, 2720420, 2720025, 2720002, 2720139, 2720029, 2720355, 2720444, 2719974, 2720007, 40664738, 2720126, 2720453, 2720465, 2720378, 2720463, 2720235, 2720092, 2720475, 2720273, 2720428, 2720396, 2720171, 2720464, 2720030, 2720012, 2720042, 2720108, 2720132, 2720469, 2719997, 2720385, 2720478, 2720130, 2720001, 2720048, 2720363, 2720150, 2719994, 2720224, 2720047, 2720437, 2720066, 2720435, 44782263, 2720366, 2720040, 2720421, 2720155, 2720068, 2720161, 2720418, 2720483, 2720354, 2720020, 2720090, 2720472, 2720117, 2720142, 2720144, 2720009, 2720423, 2720133, 2720125, 2720019, 2720446, 2720078, 2720160, 2720451, 2720208, 2720317, 2720028, 2720118, 2720240, 2720140, 2720315, 2720179, 2720454, 44782257, 2720477,
 2720239, 44782256, 2720083, 44782265, 2720081, 2616718, 2720080, 2720112, 2720056, 2720342, 2720149, 2720051, 2720061, 2720433, 2720216, 2720146, 44782266, 2720441, 40218592, 2720218, 2720424, 44782249, 2720445, 2720076, 44782260, 2720045) 
                            AND is_standard = 1 )) criteria ) )
                )
            ) d_exposure 
        LEFT JOIN
            `concept` d_standard_concept 
                ON d_exposure.drug_concept_id = d_standard_concept.concept_id 
        LEFT JOIN
            `concept` d_type 
                ON d_exposure.drug_type_concept_id = d_type.concept_id 
        LEFT JOIN
            `concept` d_route 
                ON d_exposure.route_concept_id = d_route.concept_id 
        LEFT JOIN
            `visit_occurrence` v 
                ON d_exposure.visit_occurrence_id = v.visit_occurrence_id 
        LEFT JOIN
            `concept` d_visit 
                ON v.visit_concept_id = d_visit.concept_id 
        LEFT JOIN
            `concept` d_source_concept 
                ON d_exposure.drug_source_concept_id = d_source_concept.concept_id", sep="")

# Formulate a Cloud Storage destination path for the data exported from BigQuery.
# NOTE: By default data exported multiple times on the same day will overwrite older copies.
#       But data exported on a different days will write to a new location so that historical
#       copies can be kept as the dataset definition is changed.
drug_34437487_path <- file.path(
  Sys.getenv("WORKSPACE_BUCKET"),
  "bq_exports",
  Sys.getenv("OWNER_EMAIL"),
  strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
  "drug_34437487",
  "drug_34437487_*.csv")
message(str_glue('The data will be written to {drug_34437487_path}. Use this path when reading ',
                 'the data into your notebooks in the future.'))

# Perform the query and export the dataset to Cloud Storage as CSV files.
# NOTE: You only need to run `bq_table_save` once. After that, you can
#       just read data from the CSVs in Cloud Storage.
bq_table_save(
  bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_34437487_drug_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
  drug_34437487_path,
  destination_format = "CSV")


# Read the data directly from Cloud Storage into memory.
# NOTE: Alternatively you can `gsutil -m cp {drug_34437487_path}` to copy these files
#       to the Jupyter disk.
read_bq_export_from_workspace_bucket <- function(export_path) {
  col_types <- cols(standard_concept_name = col_character(), standard_concept_code = col_character(), standard_vocabulary = col_character(), drug_type_concept_name = col_character(), stop_reason = col_character(), sig = col_character(), route_concept_name = col_character(), lot_number = col_character(), visit_occurrence_concept_name = col_character(), drug_source_value = col_character(), source_concept_name = col_character(), source_concept_code = col_character(), source_vocabulary = col_character(), route_source_value = col_character(), dose_unit_source_value = col_character())
  bind_rows(
    map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
        function(csv) {
          message(str_glue('Loading {csv}.'))
          chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
          if (is.null(col_types)) {
            col_types <- spec(chunk)
          }
          chunk
        }))
}
dataset_34437487_drug_df <- read_bq_export_from_workspace_bucket(drug_34437487_path)

dim(dataset_34437487_drug_df)

head(dataset_34437487_drug_df, 5)
library(tidyverse)
library(bigrquery)

# This query represents dataset "disability_carecascade" for domain "observation" and was generated for All of Us Registered Tier Dataset v8
dataset_34437487_observation_sql <- paste("
    SELECT
        observation.person_id,
        observation.observation_concept_id,
        o_standard_concept.concept_name as standard_concept_name,
        o_standard_concept.concept_code as standard_concept_code,
        o_standard_concept.vocabulary_id as standard_vocabulary,
        observation.observation_datetime,
        observation.observation_type_concept_id,
        o_type.concept_name as observation_type_concept_name,
        observation.value_as_number,
        observation.value_as_string,
        observation.value_as_concept_id,
        o_value.concept_name as value_as_concept_name,
        observation.qualifier_concept_id,
        o_qualifier.concept_name as qualifier_concept_name,
        observation.unit_concept_id,
        o_unit.concept_name as unit_concept_name,
        observation.visit_occurrence_id,
        o_visit.concept_name as visit_occurrence_concept_name,
        observation.observation_source_value,
        observation.observation_source_concept_id,
        o_source_concept.concept_name as source_concept_name,
        o_source_concept.concept_code as source_concept_code,
        o_source_concept.vocabulary_id as source_vocabulary,
        observation.unit_source_value,
        observation.qualifier_source_value,
        observation.value_source_concept_id,
        observation.value_source_value,
        observation.questionnaire_response_id 
    FROM
        ( SELECT
            * 
        FROM
            `observation` observation 
        WHERE
            (
                observation_source_concept_id IN (1314315, 1585636, 1585692, 1585698, 2514536, 2514537, 35225282, 35225284, 35225285, 35225436, 37402463, 44821564, 44822705, 44827367, 44827368, 44827369, 44827370, 44828554, 44831951, 44831957, 44834285, 44835482, 44837833, 45536716, 45542497, 45542498, 45546347, 45546348, 45546358, 45547378, 45551158, 45551165, 45560708, 45571391, 45595566, 45599435, 45609015, 725538, 725539, 725542, 725543, 725552, 725588)
            )  
            AND (
                observation.PERSON_ID IN (SELECT
                    distinct person_id  
                FROM
                    `cb_search_person` cb_search_person  
                WHERE
                    cb_search_person.person_id IN (SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN(SELECT
                                DISTINCT c.concept_id 
                            FROM
                                `cb_criteria` c 
                            JOIN
                                (SELECT
                                    CAST(cr.id as string) AS id       
                                FROM
                                    `cb_criteria` cr       
                                WHERE
                                    concept_id IN (44819543, 1568415, 35207238, 44827678, 1569071, 35225282, 1576172, 44832361, 45563315, 44828872, 1576239, 44827366, 44822999, 44837827, 1569075, 1576311, 1568407, 44823473, 44824618, 1568908, 35207243, 1568408, 44823020, 35207242, 44833491, 1576291, 44823838, 35207240, 44828852, 1568262, 1568412, 35207239, 44833401, 35207241)       
                                    AND full_text LIKE '%_rank1]%'      ) a 
                                    ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                                    OR c.path LIKE CONCAT('%.', a.id) 
                                    OR c.path LIKE CONCAT(a.id, '.%') 
                                    OR c.path = a.id) 
                            WHERE
                                is_standard = 0 
                                AND is_selectable = 1) 
                            AND is_standard = 0 )) criteria 
                    UNION
                    DISTINCT SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN (927179, 927186, 927180, 2314299, 927182, 927181, 927183, 2314297, 2314312, 927184) 
                            AND is_standard = 0 )) criteria 
                    UNION
                    DISTINCT SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN (2720162, 2720060, 2720074, 2720152, 2720359, 2720313, 2720427, 2720381, 2720479, 40660167, 2719999, 2719992, 44786598, 2720063, 2720141, 2720455, 2719976, 2720086, 40662114, 44786597, 2720369, 2720466, 2720123, 44782259, 2720422, 2720091, 2720383, 2616864, 2720138, 2720434, 2720257, 2720481, 2720259, 2720456, 2720164, 2720169, 2720096, 2720005, 2720024, 44782268, 2720217, 2720450, 2720044, 2720432, 2720136, 2720392, 2720127, 2719988, 2720436, 2720049, 2720046, 2720425, 2720470, 44782254, 2719971, 44782262, 44782255, 2720124, 2720438, 43533236, 2720131, 2720082, 40217612, 2720135, 2720065, 2720331, 2720476, 2720236, 2720458, 2720089, 2720027, 2720448, 2720417, 2720443, 43533220, 2720094, 2720382, 2720480, 2720137, 2720413, 2720154, 2720462, 2720110, 2720026, 44782253, 44782258, 2720230, 2720168, 40664531, 2720461, 2616774, 2720232, 953198, 2720156, 2720379, 2720358, 2720143, 937587, 2720431, 2720449, 44782264, 2720075, 2720223, 2720467, 915813,
 2720447, 2720031, 40662117, 2720035, 2720395, 2719973, 2720429, 2720416, 2720370, 2720368, 2720414, 2720023, 2720384, 2720095, 2720442, 2720474, 2720377, 2720482, 2720158, 2719980, 2720052, 2720231, 2720468, 2720233, 2720151, 2720386, 2720419, 2720256, 2720248, 2720018, 2720314, 2720420, 2720025, 2720002, 2720139, 2720029, 2720355, 2720444, 2719974, 2720007, 40664738, 2720126, 2720453, 2720465, 2720378, 2720463, 2720235, 2720092, 2720475, 2720273, 2720428, 2720396, 2720171, 2720464, 2720030, 2720012, 2720042, 2720108, 2720132, 2720469, 2719997, 2720385, 2720478, 2720130, 2720001, 2720048, 2720363, 2720150, 2719994, 2720224, 2720047, 2720437, 2720066, 2720435, 44782263, 2720366, 2720040, 2720421, 2720155, 2720068, 2720161, 2720418, 2720483, 2720354, 2720020, 2720090, 2720472, 2720117, 2720142, 2720144, 2720009, 2720423, 2720133, 2720125, 2720019, 2720446, 2720078, 2720160, 2720451, 2720208, 2720317, 2720028, 2720118, 2720240, 2720140, 2720315, 2720179, 2720454, 44782257, 2720477,
 2720239, 44782256, 2720083, 44782265, 2720081, 2616718, 2720080, 2720112, 2720056, 2720342, 2720149, 2720051, 2720061, 2720433, 2720216, 2720146, 44782266, 2720441, 40218592, 2720218, 2720424, 44782249, 2720445, 2720076, 44782260, 2720045) 
                            AND is_standard = 1 )) criteria ) )
                )
            ) observation 
        LEFT JOIN
            `concept` o_standard_concept 
                ON observation.observation_concept_id = o_standard_concept.concept_id 
        LEFT JOIN
            `concept` o_type 
                ON observation.observation_type_concept_id = o_type.concept_id 
        LEFT JOIN
            `concept` o_value 
                ON observation.value_as_concept_id = o_value.concept_id 
        LEFT JOIN
            `concept` o_qualifier 
                ON observation.qualifier_concept_id = o_qualifier.concept_id 
        LEFT JOIN
            `concept` o_unit 
                ON observation.unit_concept_id = o_unit.concept_id 
        LEFT JOIN
            `visit_occurrence` v 
                ON observation.visit_occurrence_id = v.visit_occurrence_id 
        LEFT JOIN
            `concept` o_visit 
                ON v.visit_concept_id = o_visit.concept_id 
        LEFT JOIN
            `concept` o_source_concept 
                ON observation.observation_source_concept_id = o_source_concept.concept_id", sep="")

# Formulate a Cloud Storage destination path for the data exported from BigQuery.
# NOTE: By default data exported multiple times on the same day will overwrite older copies.
#       But data exported on a different days will write to a new location so that historical
#       copies can be kept as the dataset definition is changed.
observation_34437487_path <- file.path(
  Sys.getenv("WORKSPACE_BUCKET"),
  "bq_exports",
  Sys.getenv("OWNER_EMAIL"),
  strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
  "observation_34437487",
  "observation_34437487_*.csv")
message(str_glue('The data will be written to {observation_34437487_path}. Use this path when reading ',
                 'the data into your notebooks in the future.'))

# Perform the query and export the dataset to Cloud Storage as CSV files.
# NOTE: You only need to run `bq_table_save` once. After that, you can
#       just read data from the CSVs in Cloud Storage.
bq_table_save(
  bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_34437487_observation_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
  observation_34437487_path,
  destination_format = "CSV")


# Read the data directly from Cloud Storage into memory.
# NOTE: Alternatively you can `gsutil -m cp {observation_34437487_path}` to copy these files
#       to the Jupyter disk.
read_bq_export_from_workspace_bucket <- function(export_path) {
  col_types <- cols(standard_concept_name = col_character(), standard_concept_code = col_character(), standard_vocabulary = col_character(), observation_type_concept_name = col_character(), value_as_string = col_character(), value_as_concept_name = col_character(), qualifier_concept_name = col_character(), unit_concept_name = col_character(), visit_occurrence_concept_name = col_character(), observation_source_value = col_character(), source_concept_name = col_character(), source_concept_code = col_character(), source_vocabulary = col_character(), unit_source_value = col_character(), qualifier_source_value = col_character(), value_source_value = col_character())
  bind_rows(
    map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
        function(csv) {
          message(str_glue('Loading {csv}.'))
          chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
          if (is.null(col_types)) {
            col_types <- spec(chunk)
          }
          chunk
        }))
}
dataset_34437487_observation_df <- read_bq_export_from_workspace_bucket(observation_34437487_path)

dim(dataset_34437487_observation_df)

head(dataset_34437487_observation_df, 5)
library(tidyverse)
library(bigrquery)

# This query represents dataset "disability_carecascade" for domain "condition" and was generated for All of Us Registered Tier Dataset v8
dataset_34437487_condition_sql <- paste("
    SELECT
        c_occurrence.person_id,
        c_occurrence.condition_concept_id,
        c_standard_concept.concept_name as standard_concept_name,
        c_standard_concept.concept_code as standard_concept_code,
        c_standard_concept.vocabulary_id as standard_vocabulary,
        c_occurrence.condition_start_datetime,
        c_occurrence.condition_end_datetime,
        c_occurrence.condition_type_concept_id,
        c_type.concept_name as condition_type_concept_name,
        c_occurrence.stop_reason,
        c_occurrence.visit_occurrence_id,
        visit.concept_name as visit_occurrence_concept_name,
        c_occurrence.condition_source_value,
        c_occurrence.condition_source_concept_id,
        c_source_concept.concept_name as source_concept_name,
        c_source_concept.concept_code as source_concept_code,
        c_source_concept.vocabulary_id as source_vocabulary,
        c_occurrence.condition_status_source_value,
        c_occurrence.condition_status_concept_id,
        c_status.concept_name as condition_status_concept_name 
    FROM
        ( SELECT
            * 
        FROM
            `condition_occurrence` c_occurrence 
        WHERE
            (
                condition_source_concept_id IN (SELECT
                    DISTINCT c.concept_id 
                FROM
                    `cb_criteria` c 
                JOIN
                    (SELECT
                        CAST(cr.id as string) AS id       
                    FROM
                        `cb_criteria` cr       
                    WHERE
                        concept_id IN (1326498, 1326537, 1326538, 1326539, 1326541, 1326542, 1326543, 1326546, 1326547, 1326549, 1326550, 1326552, 1326553, 1326555, 1326556, 1326558, 1326559, 1326560, 1326562, 1326563, 1326564, 1326567, 1326568, 1326570, 1326571, 1326573, 1326575, 1326577, 1326579, 1326580, 1326581, 1326583, 1326584, 1326586, 1326587, 1568106, 1568107, 1568111, 1568113, 1568115, 1568262, 1568407, 1568411, 1568413, 1568414, 1568422, 1568908, 1569071, 1569072, 1569075, 1569081, 1576172, 17836, 17839, 17841, 35207238, 35207239, 35207240, 35207241, 35207242, 35207243, 35207254, 35207255, 35207257, 35207258, 35207259, 35207479, 35207480, 35207481, 35207482, 35207483, 35207484, 35207485, 35207486, 35207487, 35207488, 35207573, 35207574, 35207575, 35207576, 35207616, 35207617, 35207618, 35207619, 35207620, 35207621, 35207622, 35225286, 35225287, 35225288, 35225373, 35225435, 35225437, 37200474, 37200475, 37200477, 37200478, 37200480, 37200481, 37402463, 44819543, 44819555,
 44819585, 44819634, 44819635, 44819636, 44819637, 44819688, 44820728, 44820763, 44820764, 44820765, 44820802, 44820803, 44820804, 44820805, 44820806, 44820848, 44820849, 44821564, 44821853, 44821893, 44821894, 44821944, 44821945, 44821946, 44822705, 44822989, 44823020, 44823021, 44823022, 44823023, 44823024, 44823064, 44823104, 44823105, 44823106, 44823107, 44823473, 44823837, 44824126, 44824143, 44824158, 44824159, 44824230, 44824231, 44824618, 44825015, 44825319, 44825335, 44825378, 44825424, 44826517, 44826546, 44826547, 44826553, 44826584, 44827363, 44827368, 44827369, 44827370, 44827371, 44827668, 44827678, 44827693, 44827696, 44827776, 44828554, 44828852, 44828872, 44828873, 44828875, 44828924, 44828925, 44828926, 44828927, 44828967, 44829933, 44829939, 44829967, 44829968, 44829969, 44829970, 44830019, 44830020, 44830021, 44830022, 44830023, 44830024, 44830073, 44830074, 44830803, 44830804, 44831172, 44831173, 44831174, 44831223, 44831224, 44831225, 44832247, 44832276, 44832277,
 44832278, 44832321, 44832322, 44832323, 44832325, 44832361, 44832362, 44833106, 44833111, 44833401, 44833443, 44833491, 44833492, 44833493, 44833494, 44833495, 44833551, 44833552, 44834284, 44834286, 44834602, 44834628, 44834629, 44834633, 44834672, 44834673, 44834674, 44834675, 44834713, 44835476, 44835483, 44835800, 44835804, 44835835, 44835836, 44835872, 44835873, 44835874, 44835875, 44835876, 44835920, 44836978, 44836979, 44836982, 44837006, 44837010, 44837011, 44837046, 44837047, 44837093, 44837828, 44837833, 45533067, 45533068, 45533169, 45533422, 45536716, 45536718, 45536719, 45536721, 45537692, 45537694, 45537695, 45538138, 45538139, 45538140, 45538142, 45538322, 45538358, 45542480, 45542481, 45542482, 45542483, 45542484, 45542507, 45542792, 45542793, 45542794, 45542795, 45542796, 45542797, 45542798, 45542906, 45542907, 45542909, 45542910, 45542912, 45543088, 45543145, 45543146, 45546347, 45546348, 45546349, 45546355, 45546356, 45546358, 45547340, 45547364, 45547365, 45547366,
 45547367, 45547369, 45547760, 45547763, 45547995, 45551158, 45551159, 45551165, 45552105, 45552133, 45552134, 45552135, 45552137, 45552138, 45552549, 45552723, 45552761, 45552762, 45552763, 45555951, 45555954, 45555955, 45556872, 45556873, 45556876, 45556877, 45557159, 45557160, 45557162, 45557257, 45557260, 45557477, 45557525, 45560702, 45560708, 45562007, 45562105, 45562108, 45562109, 45562286, 45562287, 45562325, 45563315, 45565528, 45566472, 45566484, 45566782, 45566784, 45566785, 45566786, 45566787, 45566902, 45566903, 45566905, 45566907, 45567153, 45567154, 45570391, 45570392, 45570393, 45571712, 45571713, 45571714, 45571828, 45571829, 45571830, 45571831, 45571832, 45572017, 45572018, 45572019, 45575247, 45576203, 45576204, 45576205, 45576206, 45576207, 45576208, 45576209, 45576499, 45576500, 45576501, 45576612, 45576613, 45576795, 45576849, 45576851, 45576853, 45580099, 45581085, 45581086, 45581409, 45581411, 45581515, 45581516, 45581518, 45581519, 45581709, 45581752, 45581754,
 45581755, 45581756, 45581757, 45581758, 45584902, 45584904, 45584906, 45585871, 45586193, 45586196, 45586197, 45586198, 45586315, 45586316, 45586556, 45589751, 45589755, 45591090, 45591091, 45591095, 45591198, 45591199, 45591200, 45591445, 45594616, 45594617, 45594622, 45595554, 45595555, 45595557, 45595558, 45595570, 45595854, 45595856, 45595857, 45595962, 45595963, 45599435, 45599437, 45599442, 45600368, 45600369, 45600370, 45600371, 45600392, 45600697, 45600806, 45600807, 45600809, 45600810, 45600968, 45600969, 45604250, 45604253, 45604255, 45604256, 45605168, 45605169, 45605170, 45605458, 45605459, 45605460, 45605461, 45605464, 45605573, 45605574, 45605766, 45605767, 45605768, 45609015, 45609989, 45609990, 45609991, 725281, 725538, 725539, 725542, 725543, 725550, 725552, 725563, 725588, 725592, 766352)       
                        AND full_text LIKE '%_rank1]%'      ) a 
                        ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                        OR c.path LIKE CONCAT('%.', a.id) 
                        OR c.path LIKE CONCAT(a.id, '.%') 
                        OR c.path = a.id) 
                WHERE
                    is_standard = 0 
                    AND is_selectable = 1)
            )  
            AND (
                c_occurrence.PERSON_ID IN (SELECT
                    distinct person_id  
                FROM
                    `cb_search_person` cb_search_person  
                WHERE
                    cb_search_person.person_id IN (SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN(SELECT
                                DISTINCT c.concept_id 
                            FROM
                                `cb_criteria` c 
                            JOIN
                                (SELECT
                                    CAST(cr.id as string) AS id       
                                FROM
                                    `cb_criteria` cr       
                                WHERE
                                    concept_id IN (44819543, 1568415, 35207238, 44827678, 1569071, 35225282, 1576172, 44832361, 45563315, 44828872, 1576239, 44827366, 44822999, 44837827, 1569075, 1576311, 1568407, 44823473, 44824618, 1568908, 35207243, 1568408, 44823020, 35207242, 44833491, 1576291, 44823838, 35207240, 44828852, 1568262, 1568412, 35207239, 44833401, 35207241)       
                                    AND full_text LIKE '%_rank1]%'      ) a 
                                    ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                                    OR c.path LIKE CONCAT('%.', a.id) 
                                    OR c.path LIKE CONCAT(a.id, '.%') 
                                    OR c.path = a.id) 
                            WHERE
                                is_standard = 0 
                                AND is_selectable = 1) 
                            AND is_standard = 0 )) criteria 
                    UNION
                    DISTINCT SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN (927179, 927186, 927180, 2314299, 927182, 927181, 927183, 2314297, 2314312, 927184) 
                            AND is_standard = 0 )) criteria 
                    UNION
                    DISTINCT SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN (2720162, 2720060, 2720074, 2720152, 2720359, 2720313, 2720427, 2720381, 2720479, 40660167, 2719999, 2719992, 44786598, 2720063, 2720141, 2720455, 2719976, 2720086, 40662114, 44786597, 2720369, 2720466, 2720123, 44782259, 2720422, 2720091, 2720383, 2616864, 2720138, 2720434, 2720257, 2720481, 2720259, 2720456, 2720164, 2720169, 2720096, 2720005, 2720024, 44782268, 2720217, 2720450, 2720044, 2720432, 2720136, 2720392, 2720127, 2719988, 2720436, 2720049, 2720046, 2720425, 2720470, 44782254, 2719971, 44782262, 44782255, 2720124, 2720438, 43533236, 2720131, 2720082, 40217612, 2720135, 2720065, 2720331, 2720476, 2720236, 2720458, 2720089, 2720027, 2720448, 2720417, 2720443, 43533220, 2720094, 2720382, 2720480, 2720137, 2720413, 2720154, 2720462, 2720110, 2720026, 44782253, 44782258, 2720230, 2720168, 40664531, 2720461, 2616774, 2720232, 953198, 2720156, 2720379, 2720358, 2720143, 937587, 2720431, 2720449, 44782264, 2720075, 2720223, 2720467, 915813,
 2720447, 2720031, 40662117, 2720035, 2720395, 2719973, 2720429, 2720416, 2720370, 2720368, 2720414, 2720023, 2720384, 2720095, 2720442, 2720474, 2720377, 2720482, 2720158, 2719980, 2720052, 2720231, 2720468, 2720233, 2720151, 2720386, 2720419, 2720256, 2720248, 2720018, 2720314, 2720420, 2720025, 2720002, 2720139, 2720029, 2720355, 2720444, 2719974, 2720007, 40664738, 2720126, 2720453, 2720465, 2720378, 2720463, 2720235, 2720092, 2720475, 2720273, 2720428, 2720396, 2720171, 2720464, 2720030, 2720012, 2720042, 2720108, 2720132, 2720469, 2719997, 2720385, 2720478, 2720130, 2720001, 2720048, 2720363, 2720150, 2719994, 2720224, 2720047, 2720437, 2720066, 2720435, 44782263, 2720366, 2720040, 2720421, 2720155, 2720068, 2720161, 2720418, 2720483, 2720354, 2720020, 2720090, 2720472, 2720117, 2720142, 2720144, 2720009, 2720423, 2720133, 2720125, 2720019, 2720446, 2720078, 2720160, 2720451, 2720208, 2720317, 2720028, 2720118, 2720240, 2720140, 2720315, 2720179, 2720454, 44782257, 2720477,
 2720239, 44782256, 2720083, 44782265, 2720081, 2616718, 2720080, 2720112, 2720056, 2720342, 2720149, 2720051, 2720061, 2720433, 2720216, 2720146, 44782266, 2720441, 40218592, 2720218, 2720424, 44782249, 2720445, 2720076, 44782260, 2720045) 
                            AND is_standard = 1 )) criteria ) )
                )
            ) c_occurrence 
        LEFT JOIN
            `concept` c_standard_concept 
                ON c_occurrence.condition_concept_id = c_standard_concept.concept_id 
        LEFT JOIN
            `concept` c_type 
                ON c_occurrence.condition_type_concept_id = c_type.concept_id 
        LEFT JOIN
            `visit_occurrence` v 
                ON c_occurrence.visit_occurrence_id = v.visit_occurrence_id 
        LEFT JOIN
            `concept` visit 
                ON v.visit_concept_id = visit.concept_id 
        LEFT JOIN
            `concept` c_source_concept 
                ON c_occurrence.condition_source_concept_id = c_source_concept.concept_id 
        LEFT JOIN
            `concept` c_status 
                ON c_occurrence.condition_status_concept_id = c_status.concept_id", sep="")

# Formulate a Cloud Storage destination path for the data exported from BigQuery.
# NOTE: By default data exported multiple times on the same day will overwrite older copies.
#       But data exported on a different days will write to a new location so that historical
#       copies can be kept as the dataset definition is changed.
condition_34437487_path <- file.path(
  Sys.getenv("WORKSPACE_BUCKET"),
  "bq_exports",
  Sys.getenv("OWNER_EMAIL"),
  strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
  "condition_34437487",
  "condition_34437487_*.csv")
message(str_glue('The data will be written to {condition_34437487_path}. Use this path when reading ',
                 'the data into your notebooks in the future.'))

# Perform the query and export the dataset to Cloud Storage as CSV files.
# NOTE: You only need to run `bq_table_save` once. After that, you can
#       just read data from the CSVs in Cloud Storage.
bq_table_save(
  bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_34437487_condition_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
  condition_34437487_path,
  destination_format = "CSV")


# Read the data directly from Cloud Storage into memory.
# NOTE: Alternatively you can `gsutil -m cp {condition_34437487_path}` to copy these files
#       to the Jupyter disk.
read_bq_export_from_workspace_bucket <- function(export_path) {
  col_types <- cols(standard_concept_name = col_character(), standard_concept_code = col_character(), standard_vocabulary = col_character(), condition_type_concept_name = col_character(), stop_reason = col_character(), visit_occurrence_concept_name = col_character(), condition_source_value = col_character(), source_concept_name = col_character(), source_concept_code = col_character(), source_vocabulary = col_character(), condition_status_source_value = col_character(), condition_status_concept_name = col_character())
  bind_rows(
    map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
        function(csv) {
          message(str_glue('Loading {csv}.'))
          chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
          if (is.null(col_types)) {
            col_types <- spec(chunk)
          }
          chunk
        }))
}
dataset_34437487_condition_df <- read_bq_export_from_workspace_bucket(condition_34437487_path)

dim(dataset_34437487_condition_df)

head(dataset_34437487_condition_df, 5)
library(tidyverse)
library(bigrquery)

# This query represents dataset "disability_carecascade" for domain "measurement" and was generated for All of Us Registered Tier Dataset v8
dataset_34437487_measurement_sql <- paste("
    SELECT
        measurement.person_id,
        measurement.measurement_concept_id,
        m_standard_concept.concept_name as standard_concept_name,
        m_standard_concept.concept_code as standard_concept_code,
        m_standard_concept.vocabulary_id as standard_vocabulary,
        measurement.measurement_datetime,
        measurement.measurement_type_concept_id,
        m_type.concept_name as measurement_type_concept_name,
        measurement.operator_concept_id,
        m_operator.concept_name as operator_concept_name,
        measurement.value_as_number,
        measurement.value_as_concept_id,
        m_value.concept_name as value_as_concept_name,
        measurement.unit_concept_id,
        m_unit.concept_name as unit_concept_name,
        measurement.range_low,
        measurement.range_high,
        measurement.visit_occurrence_id,
        m_visit.concept_name as visit_occurrence_concept_name,
        measurement.measurement_source_value,
        measurement.measurement_source_concept_id,
        m_source_concept.concept_name as source_concept_name,
        m_source_concept.concept_code as source_concept_code,
        m_source_concept.vocabulary_id as source_vocabulary,
        measurement.unit_source_value,
        measurement.value_source_value 
    FROM
        ( SELECT
            * 
        FROM
            `measurement` measurement 
        WHERE
            (
                measurement_concept_id IN (SELECT
                    DISTINCT c.concept_id 
                FROM
                    `cb_criteria` c 
                JOIN
                    (SELECT
                        CAST(cr.id as string) AS id       
                    FROM
                        `cb_criteria` cr       
                    WHERE
                        concept_id IN (37016945)       
                        AND full_text LIKE '%_rank1]%'      ) a 
                        ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                        OR c.path LIKE CONCAT('%.', a.id) 
                        OR c.path LIKE CONCAT(a.id, '.%') 
                        OR c.path = a.id) 
                WHERE
                    is_standard = 1 
                    AND is_selectable = 1)
            )  
            AND (
                measurement.PERSON_ID IN (SELECT
                    distinct person_id  
                FROM
                    `cb_search_person` cb_search_person  
                WHERE
                    cb_search_person.person_id IN (SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN(SELECT
                                DISTINCT c.concept_id 
                            FROM
                                `cb_criteria` c 
                            JOIN
                                (SELECT
                                    CAST(cr.id as string) AS id       
                                FROM
                                    `cb_criteria` cr       
                                WHERE
                                    concept_id IN (44819543, 1568415, 35207238, 44827678, 1569071, 35225282, 1576172, 44832361, 45563315, 44828872, 1576239, 44827366, 44822999, 44837827, 1569075, 1576311, 1568407, 44823473, 44824618, 1568908, 35207243, 1568408, 44823020, 35207242, 44833491, 1576291, 44823838, 35207240, 44828852, 1568262, 1568412, 35207239, 44833401, 35207241)       
                                    AND full_text LIKE '%_rank1]%'      ) a 
                                    ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                                    OR c.path LIKE CONCAT('%.', a.id) 
                                    OR c.path LIKE CONCAT(a.id, '.%') 
                                    OR c.path = a.id) 
                            WHERE
                                is_standard = 0 
                                AND is_selectable = 1) 
                            AND is_standard = 0 )) criteria 
                    UNION
                    DISTINCT SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN (927179, 927186, 927180, 2314299, 927182, 927181, 927183, 2314297, 2314312, 927184) 
                            AND is_standard = 0 )) criteria 
                    UNION
                    DISTINCT SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN (2720162, 2720060, 2720074, 2720152, 2720359, 2720313, 2720427, 2720381, 2720479, 40660167, 2719999, 2719992, 44786598, 2720063, 2720141, 2720455, 2719976, 2720086, 40662114, 44786597, 2720369, 2720466, 2720123, 44782259, 2720422, 2720091, 2720383, 2616864, 2720138, 2720434, 2720257, 2720481, 2720259, 2720456, 2720164, 2720169, 2720096, 2720005, 2720024, 44782268, 2720217, 2720450, 2720044, 2720432, 2720136, 2720392, 2720127, 2719988, 2720436, 2720049, 2720046, 2720425, 2720470, 44782254, 2719971, 44782262, 44782255, 2720124, 2720438, 43533236, 2720131, 2720082, 40217612, 2720135, 2720065, 2720331, 2720476, 2720236, 2720458, 2720089, 2720027, 2720448, 2720417, 2720443, 43533220, 2720094, 2720382, 2720480, 2720137, 2720413, 2720154, 2720462, 2720110, 2720026, 44782253, 44782258, 2720230, 2720168, 40664531, 2720461, 2616774, 2720232, 953198, 2720156, 2720379, 2720358, 2720143, 937587, 2720431, 2720449, 44782264, 2720075, 2720223, 2720467, 915813,
 2720447, 2720031, 40662117, 2720035, 2720395, 2719973, 2720429, 2720416, 2720370, 2720368, 2720414, 2720023, 2720384, 2720095, 2720442, 2720474, 2720377, 2720482, 2720158, 2719980, 2720052, 2720231, 2720468, 2720233, 2720151, 2720386, 2720419, 2720256, 2720248, 2720018, 2720314, 2720420, 2720025, 2720002, 2720139, 2720029, 2720355, 2720444, 2719974, 2720007, 40664738, 2720126, 2720453, 2720465, 2720378, 2720463, 2720235, 2720092, 2720475, 2720273, 2720428, 2720396, 2720171, 2720464, 2720030, 2720012, 2720042, 2720108, 2720132, 2720469, 2719997, 2720385, 2720478, 2720130, 2720001, 2720048, 2720363, 2720150, 2719994, 2720224, 2720047, 2720437, 2720066, 2720435, 44782263, 2720366, 2720040, 2720421, 2720155, 2720068, 2720161, 2720418, 2720483, 2720354, 2720020, 2720090, 2720472, 2720117, 2720142, 2720144, 2720009, 2720423, 2720133, 2720125, 2720019, 2720446, 2720078, 2720160, 2720451, 2720208, 2720317, 2720028, 2720118, 2720240, 2720140, 2720315, 2720179, 2720454, 44782257, 2720477,
 2720239, 44782256, 2720083, 44782265, 2720081, 2616718, 2720080, 2720112, 2720056, 2720342, 2720149, 2720051, 2720061, 2720433, 2720216, 2720146, 44782266, 2720441, 40218592, 2720218, 2720424, 44782249, 2720445, 2720076, 44782260, 2720045) 
                            AND is_standard = 1 )) criteria ) )
                )
            ) measurement 
        LEFT JOIN
            `concept` m_standard_concept 
                ON measurement.measurement_concept_id = m_standard_concept.concept_id 
        LEFT JOIN
            `concept` m_type 
                ON measurement.measurement_type_concept_id = m_type.concept_id 
        LEFT JOIN
            `concept` m_operator 
                ON measurement.operator_concept_id = m_operator.concept_id 
        LEFT JOIN
            `concept` m_value 
                ON measurement.value_as_concept_id = m_value.concept_id 
        LEFT JOIN
            `concept` m_unit 
                ON measurement.unit_concept_id = m_unit.concept_id 
        LEFT JOIn
            `visit_occurrence` v 
                ON measurement.visit_occurrence_id = v.visit_occurrence_id 
        LEFT JOIN
            `concept` m_visit 
                ON v.visit_concept_id = m_visit.concept_id 
        LEFT JOIN
            `concept` m_source_concept 
                ON measurement.measurement_source_concept_id = m_source_concept.concept_id", sep="")

# Formulate a Cloud Storage destination path for the data exported from BigQuery.
# NOTE: By default data exported multiple times on the same day will overwrite older copies.
#       But data exported on a different days will write to a new location so that historical
#       copies can be kept as the dataset definition is changed.
measurement_34437487_path <- file.path(
  Sys.getenv("WORKSPACE_BUCKET"),
  "bq_exports",
  Sys.getenv("OWNER_EMAIL"),
  strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
  "measurement_34437487",
  "measurement_34437487_*.csv")
message(str_glue('The data will be written to {measurement_34437487_path}. Use this path when reading ',
                 'the data into your notebooks in the future.'))

# Perform the query and export the dataset to Cloud Storage as CSV files.
# NOTE: You only need to run `bq_table_save` once. After that, you can
#       just read data from the CSVs in Cloud Storage.
bq_table_save(
  bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_34437487_measurement_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
  measurement_34437487_path,
  destination_format = "CSV")


# Read the data directly from Cloud Storage into memory.
# NOTE: Alternatively you can `gsutil -m cp {measurement_34437487_path}` to copy these files
#       to the Jupyter disk.
read_bq_export_from_workspace_bucket <- function(export_path) {
  col_types <- cols(standard_concept_name = col_character(), standard_concept_code = col_character(), standard_vocabulary = col_character(), measurement_type_concept_name = col_character(), operator_concept_name = col_character(), value_as_concept_name = col_character(), unit_concept_name = col_character(), visit_occurrence_concept_name = col_character(), measurement_source_value = col_character(), source_concept_name = col_character(), source_concept_code = col_character(), source_vocabulary = col_character(), unit_source_value = col_character(), value_source_value = col_character())
  bind_rows(
    map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
        function(csv) {
          message(str_glue('Loading {csv}.'))
          chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
          if (is.null(col_types)) {
            col_types <- spec(chunk)
          }
          chunk
        }))
}
dataset_34437487_measurement_df <- read_bq_export_from_workspace_bucket(measurement_34437487_path)

dim(dataset_34437487_measurement_df)

head(dataset_34437487_measurement_df, 5)
library(tidyverse)
library(bigrquery)

# This query represents dataset "disability_carecascade" for domain "survey" and was generated for All of Us Registered Tier Dataset v8
dataset_34437487_survey_sql <- paste("
    SELECT
        answer.person_id,
        answer.survey_datetime,
        answer.survey,
        answer.question_concept_id,
        answer.question,
        answer.answer_concept_id,
        answer.answer,
        answer.survey_version_concept_id,
        answer.survey_version_name  
    FROM
        `ds_survey` answer   
    WHERE
        (
            question_concept_id IN (1585636, 1585692, 1585698)
        )  
        AND (
            answer.PERSON_ID IN (SELECT
                distinct person_id  
            FROM
                `cb_search_person` cb_search_person  
            WHERE
                cb_search_person.person_id IN (SELECT
                    criteria.person_id 
                FROM
                    (SELECT
                        DISTINCT person_id, entry_date, concept_id 
                    FROM
                        `cb_search_all_events` 
                    WHERE
                        (concept_id IN(SELECT
                            DISTINCT c.concept_id 
                        FROM
                            `cb_criteria` c 
                        JOIN
                            (SELECT
                                CAST(cr.id as string) AS id       
                            FROM
                                `cb_criteria` cr       
                            WHERE
                                concept_id IN (44819543, 1568415, 35207238, 44827678, 1569071, 35225282, 1576172, 44832361, 45563315, 44828872, 1576239, 44827366, 44822999, 44837827, 1569075, 1576311, 1568407, 44823473, 44824618, 1568908, 35207243, 1568408, 44823020, 35207242, 44833491, 1576291, 44823838, 35207240, 44828852, 1568262, 1568412, 35207239, 44833401, 35207241)       
                                AND full_text LIKE '%_rank1]%'      ) a 
                                ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                                OR c.path LIKE CONCAT('%.', a.id) 
                                OR c.path LIKE CONCAT(a.id, '.%') 
                                OR c.path = a.id) 
                        WHERE
                            is_standard = 0 
                            AND is_selectable = 1) 
                        AND is_standard = 0 )) criteria 
                UNION
                DISTINCT SELECT
                    criteria.person_id 
                FROM
                    (SELECT
                        DISTINCT person_id, entry_date, concept_id 
                    FROM
                        `cb_search_all_events` 
                    WHERE
                        (concept_id IN (927179, 927186, 927180, 2314299, 927182, 927181, 927183, 2314297, 2314312, 927184) 
                        AND is_standard = 0 )) criteria 
                UNION
                DISTINCT SELECT
                    criteria.person_id 
                FROM
                    (SELECT
                        DISTINCT person_id, entry_date, concept_id 
                    FROM
                        `cb_search_all_events` 
                    WHERE
                        (concept_id IN (2720162, 2720060, 2720074, 2720152, 2720359, 2720313, 2720427, 2720381, 2720479, 40660167, 2719999, 2719992, 44786598, 2720063, 2720141, 2720455, 2719976, 2720086, 40662114, 44786597, 2720369, 2720466, 2720123, 44782259, 2720422, 2720091, 2720383, 2616864, 2720138, 2720434, 2720257, 2720481, 2720259, 2720456, 2720164, 2720169, 2720096, 2720005, 2720024, 44782268, 2720217, 2720450, 2720044, 2720432, 2720136, 2720392, 2720127, 2719988, 2720436, 2720049, 2720046, 2720425, 2720470, 44782254, 2719971, 44782262, 44782255, 2720124, 2720438, 43533236, 2720131, 2720082, 40217612, 2720135, 2720065, 2720331, 2720476, 2720236, 2720458, 2720089, 2720027, 2720448, 2720417, 2720443, 43533220, 2720094, 2720382, 2720480, 2720137, 2720413, 2720154, 2720462, 2720110, 2720026, 44782253, 44782258, 2720230, 2720168, 40664531, 2720461, 2616774, 2720232, 953198, 2720156, 2720379, 2720358, 2720143, 937587, 2720431, 2720449, 44782264, 2720075, 2720223, 2720467, 915813,
 2720447, 2720031, 40662117, 2720035, 2720395, 2719973, 2720429, 2720416, 2720370, 2720368, 2720414, 2720023, 2720384, 2720095, 2720442, 2720474, 2720377, 2720482, 2720158, 2719980, 2720052, 2720231, 2720468, 2720233, 2720151, 2720386, 2720419, 2720256, 2720248, 2720018, 2720314, 2720420, 2720025, 2720002, 2720139, 2720029, 2720355, 2720444, 2719974, 2720007, 40664738, 2720126, 2720453, 2720465, 2720378, 2720463, 2720235, 2720092, 2720475, 2720273, 2720428, 2720396, 2720171, 2720464, 2720030, 2720012, 2720042, 2720108, 2720132, 2720469, 2719997, 2720385, 2720478, 2720130, 2720001, 2720048, 2720363, 2720150, 2719994, 2720224, 2720047, 2720437, 2720066, 2720435, 44782263, 2720366, 2720040, 2720421, 2720155, 2720068, 2720161, 2720418, 2720483, 2720354, 2720020, 2720090, 2720472, 2720117, 2720142, 2720144, 2720009, 2720423, 2720133, 2720125, 2720019, 2720446, 2720078, 2720160, 2720451, 2720208, 2720317, 2720028, 2720118, 2720240, 2720140, 2720315, 2720179, 2720454, 44782257, 2720477,
 2720239, 44782256, 2720083, 44782265, 2720081, 2616718, 2720080, 2720112, 2720056, 2720342, 2720149, 2720051, 2720061, 2720433, 2720216, 2720146, 44782266, 2720441, 40218592, 2720218, 2720424, 44782249, 2720445, 2720076, 44782260, 2720045) 
                        AND is_standard = 1 )) criteria ) )
            )", sep="")

# Formulate a Cloud Storage destination path for the data exported from BigQuery.
# NOTE: By default data exported multiple times on the same day will overwrite older copies.
#       But data exported on a different days will write to a new location so that historical
#       copies can be kept as the dataset definition is changed.
survey_34437487_path <- file.path(
  Sys.getenv("WORKSPACE_BUCKET"),
  "bq_exports",
  Sys.getenv("OWNER_EMAIL"),
  strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
  "survey_34437487",
  "survey_34437487_*.csv")
message(str_glue('The data will be written to {survey_34437487_path}. Use this path when reading ',
                 'the data into your notebooks in the future.'))

# Perform the query and export the dataset to Cloud Storage as CSV files.
# NOTE: You only need to run `bq_table_save` once. After that, you can
#       just read data from the CSVs in Cloud Storage.
bq_table_save(
  bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_34437487_survey_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
  survey_34437487_path,
  destination_format = "CSV")


# Read the data directly from Cloud Storage into memory.
# NOTE: Alternatively you can `gsutil -m cp {survey_34437487_path}` to copy these files
#       to the Jupyter disk.
read_bq_export_from_workspace_bucket <- function(export_path) {
  col_types <- cols(survey = col_character(), question = col_character(), answer = col_character(), survey_version_name = col_character())
  bind_rows(
    map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
        function(csv) {
          message(str_glue('Loading {csv}.'))
          chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
          if (is.null(col_types)) {
            col_types <- spec(chunk)
          }
          chunk
        }))
}
dataset_34437487_survey_df <- read_bq_export_from_workspace_bucket(survey_34437487_path)

dim(dataset_34437487_survey_df)

head(dataset_34437487_survey_df, 5)
library(tidyverse)
library(bigrquery)

# This query represents dataset "disability_carecascade" for domain "procedure" and was generated for All of Us Registered Tier Dataset v8
dataset_34437487_procedure_sql <- paste("
    SELECT
        procedure.person_id,
        procedure.procedure_concept_id,
        p_standard_concept.concept_name as standard_concept_name,
        p_standard_concept.concept_code as standard_concept_code,
        p_standard_concept.vocabulary_id as standard_vocabulary,
        procedure.procedure_datetime,
        procedure.procedure_type_concept_id,
        p_type.concept_name as procedure_type_concept_name,
        procedure.modifier_concept_id,
        p_modifier.concept_name as modifier_concept_name,
        procedure.quantity,
        procedure.visit_occurrence_id,
        p_visit.concept_name as visit_occurrence_concept_name,
        procedure.procedure_source_value,
        procedure.procedure_source_concept_id,
        p_source_concept.concept_name as source_concept_name,
        p_source_concept.concept_code as source_concept_code,
        p_source_concept.vocabulary_id as source_vocabulary,
        procedure.modifier_source_value 
    FROM
        ( SELECT
            * 
        FROM
            `procedure_occurrence` procedure 
        WHERE
            (
                procedure_concept_id IN (SELECT
                    DISTINCT c.concept_id 
                FROM
                    `cb_criteria` c 
                JOIN
                    (SELECT
                        CAST(cr.id as string) AS id       
                    FROM
                        `cb_criteria` cr       
                    WHERE
                        concept_id IN (2617464, 2617465, 2618100, 2618101, 2618103, 2618121, 2618123, 2618124, 2618125, 2618126, 2618128, 40217332, 40217333, 40217338, 40217339, 40664725, 4210149, 42538685, 4254232, 4254339, 4297063, 4300520, 46272515, 953268)       
                        AND full_text LIKE '%_rank1]%'      ) a 
                        ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                        OR c.path LIKE CONCAT('%.', a.id) 
                        OR c.path LIKE CONCAT(a.id, '.%') 
                        OR c.path = a.id) 
                WHERE
                    is_standard = 1 
                    AND is_selectable = 1) 
                OR  procedure_source_concept_id IN (SELECT
                    DISTINCT c.concept_id 
                FROM
                    `cb_criteria` c 
                JOIN
                    (SELECT
                        CAST(cr.id as string) AS id       
                    FROM
                        `cb_criteria` cr       
                    WHERE
                        concept_id IN (1314315, 1314321, 2314297, 2314299, 2314312, 2617464, 2617465, 2618149, 42627988, 42628505, 42628602, 927179, 927180, 927181, 927182, 927183, 927184, 927186)       
                        AND full_text LIKE '%_rank1]%'      ) a 
                        ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                        OR c.path LIKE CONCAT('%.', a.id) 
                        OR c.path LIKE CONCAT(a.id, '.%') 
                        OR c.path = a.id) 
                WHERE
                    is_standard = 0 
                    AND is_selectable = 1)
            )  
            AND (
                procedure.PERSON_ID IN (SELECT
                    distinct person_id  
                FROM
                    `cb_search_person` cb_search_person  
                WHERE
                    cb_search_person.person_id IN (SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN(SELECT
                                DISTINCT c.concept_id 
                            FROM
                                `cb_criteria` c 
                            JOIN
                                (SELECT
                                    CAST(cr.id as string) AS id       
                                FROM
                                    `cb_criteria` cr       
                                WHERE
                                    concept_id IN (44819543, 1568415, 35207238, 44827678, 1569071, 35225282, 1576172, 44832361, 45563315, 44828872, 1576239, 44827366, 44822999, 44837827, 1569075, 1576311, 1568407, 44823473, 44824618, 1568908, 35207243, 1568408, 44823020, 35207242, 44833491, 1576291, 44823838, 35207240, 44828852, 1568262, 1568412, 35207239, 44833401, 35207241)       
                                    AND full_text LIKE '%_rank1]%'      ) a 
                                    ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                                    OR c.path LIKE CONCAT('%.', a.id) 
                                    OR c.path LIKE CONCAT(a.id, '.%') 
                                    OR c.path = a.id) 
                            WHERE
                                is_standard = 0 
                                AND is_selectable = 1) 
                            AND is_standard = 0 )) criteria 
                    UNION
                    DISTINCT SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN (927179, 927186, 927180, 2314299, 927182, 927181, 927183, 2314297, 2314312, 927184) 
                            AND is_standard = 0 )) criteria 
                    UNION
                    DISTINCT SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN (2720162, 2720060, 2720074, 2720152, 2720359, 2720313, 2720427, 2720381, 2720479, 40660167, 2719999, 2719992, 44786598, 2720063, 2720141, 2720455, 2719976, 2720086, 40662114, 44786597, 2720369, 2720466, 2720123, 44782259, 2720422, 2720091, 2720383, 2616864, 2720138, 2720434, 2720257, 2720481, 2720259, 2720456, 2720164, 2720169, 2720096, 2720005, 2720024, 44782268, 2720217, 2720450, 2720044, 2720432, 2720136, 2720392, 2720127, 2719988, 2720436, 2720049, 2720046, 2720425, 2720470, 44782254, 2719971, 44782262, 44782255, 2720124, 2720438, 43533236, 2720131, 2720082, 40217612, 2720135, 2720065, 2720331, 2720476, 2720236, 2720458, 2720089, 2720027, 2720448, 2720417, 2720443, 43533220, 2720094, 2720382, 2720480, 2720137, 2720413, 2720154, 2720462, 2720110, 2720026, 44782253, 44782258, 2720230, 2720168, 40664531, 2720461, 2616774, 2720232, 953198, 2720156, 2720379, 2720358, 2720143, 937587, 2720431, 2720449, 44782264, 2720075, 2720223, 2720467, 915813,
 2720447, 2720031, 40662117, 2720035, 2720395, 2719973, 2720429, 2720416, 2720370, 2720368, 2720414, 2720023, 2720384, 2720095, 2720442, 2720474, 2720377, 2720482, 2720158, 2719980, 2720052, 2720231, 2720468, 2720233, 2720151, 2720386, 2720419, 2720256, 2720248, 2720018, 2720314, 2720420, 2720025, 2720002, 2720139, 2720029, 2720355, 2720444, 2719974, 2720007, 40664738, 2720126, 2720453, 2720465, 2720378, 2720463, 2720235, 2720092, 2720475, 2720273, 2720428, 2720396, 2720171, 2720464, 2720030, 2720012, 2720042, 2720108, 2720132, 2720469, 2719997, 2720385, 2720478, 2720130, 2720001, 2720048, 2720363, 2720150, 2719994, 2720224, 2720047, 2720437, 2720066, 2720435, 44782263, 2720366, 2720040, 2720421, 2720155, 2720068, 2720161, 2720418, 2720483, 2720354, 2720020, 2720090, 2720472, 2720117, 2720142, 2720144, 2720009, 2720423, 2720133, 2720125, 2720019, 2720446, 2720078, 2720160, 2720451, 2720208, 2720317, 2720028, 2720118, 2720240, 2720140, 2720315, 2720179, 2720454, 44782257, 2720477,
 2720239, 44782256, 2720083, 44782265, 2720081, 2616718, 2720080, 2720112, 2720056, 2720342, 2720149, 2720051, 2720061, 2720433, 2720216, 2720146, 44782266, 2720441, 40218592, 2720218, 2720424, 44782249, 2720445, 2720076, 44782260, 2720045) 
                            AND is_standard = 1 )) criteria ) )
                )
            ) procedure 
        LEFT JOIN
            `concept` p_standard_concept 
                ON procedure.procedure_concept_id = p_standard_concept.concept_id 
        LEFT JOIN
            `concept` p_type 
                ON procedure.procedure_type_concept_id = p_type.concept_id 
        LEFT JOIN
            `concept` p_modifier 
                ON procedure.modifier_concept_id = p_modifier.concept_id 
        LEFT JOIN
            `visit_occurrence` v 
                ON procedure.visit_occurrence_id = v.visit_occurrence_id 
        LEFT JOIN
            `concept` p_visit 
                ON v.visit_concept_id = p_visit.concept_id 
        LEFT JOIN
            `concept` p_source_concept 
                ON procedure.procedure_source_concept_id = p_source_concept.concept_id", sep="")

# Formulate a Cloud Storage destination path for the data exported from BigQuery.
# NOTE: By default data exported multiple times on the same day will overwrite older copies.
#       But data exported on a different days will write to a new location so that historical
#       copies can be kept as the dataset definition is changed.
procedure_34437487_path <- file.path(
  Sys.getenv("WORKSPACE_BUCKET"),
  "bq_exports",
  Sys.getenv("OWNER_EMAIL"),
  strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
  "procedure_34437487",
  "procedure_34437487_*.csv")
message(str_glue('The data will be written to {procedure_34437487_path}. Use this path when reading ',
                 'the data into your notebooks in the future.'))

# Perform the query and export the dataset to Cloud Storage as CSV files.
# NOTE: You only need to run `bq_table_save` once. After that, you can
#       just read data from the CSVs in Cloud Storage.
bq_table_save(
  bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_34437487_procedure_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
  procedure_34437487_path,
  destination_format = "CSV")


# Read the data directly from Cloud Storage into memory.
# NOTE: Alternatively you can `gsutil -m cp {procedure_34437487_path}` to copy these files
#       to the Jupyter disk.
read_bq_export_from_workspace_bucket <- function(export_path) {
  col_types <- cols(standard_concept_name = col_character(), standard_concept_code = col_character(), standard_vocabulary = col_character(), procedure_type_concept_name = col_character(), modifier_concept_name = col_character(), visit_occurrence_concept_name = col_character(), procedure_source_value = col_character(), source_concept_name = col_character(), source_concept_code = col_character(), source_vocabulary = col_character(), modifier_source_value = col_character())
  bind_rows(
    map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
        function(csv) {
          message(str_glue('Loading {csv}.'))
          chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
          if (is.null(col_types)) {
            col_types <- spec(chunk)
          }
          chunk
        }))
}
dataset_34437487_procedure_df <- read_bq_export_from_workspace_bucket(procedure_34437487_path)

dim(dataset_34437487_procedure_df)

head(dataset_34437487_procedure_df, 5)
library(tidyverse)
library(bigrquery)

# This query represents dataset "disability_carecascade" for domain "visit" and was generated for All of Us Registered Tier Dataset v8
dataset_34437487_visit_sql <- paste("
    SELECT
        visit.PERSON_ID,
        visit.visit_concept_id,
        v_standard_concept.concept_name as standard_concept_name,
        v_standard_concept.concept_code as standard_concept_code,
        v_standard_concept.vocabulary_id as standard_vocabulary,
        visit.visit_start_datetime,
        visit.visit_end_datetime,
        visit.visit_type_concept_id,
        v_type.concept_name as visit_type_concept_name,
        visit.visit_source_value,
        visit.visit_source_concept_id,
        v_source_concept.concept_name as source_concept_name,
        v_source_concept.concept_code as source_concept_code,
        v_source_concept.vocabulary_id as source_vocabulary,
        visit.admitting_source_concept_id,
        v_admitting_source_concept.concept_name as admitting_source_concept_name,
        visit.admitting_source_value,
        visit.discharge_to_concept_id,
        v_discharge.concept_name as discharge_to_concept_name,
        visit.discharge_to_source_value 
    FROM
        `visit_occurrence` visit 
    LEFT JOIN
        `concept` v_standard_concept 
            ON visit.visit_concept_id = v_standard_concept.concept_id 
    LEFT JOIN
        `concept` v_type 
            ON visit.visit_type_concept_id = v_type.concept_id 
    LEFT JOIN
        `concept` v_source_concept 
            ON visit.visit_source_concept_id = v_source_concept.concept_id 
    LEFT JOIN
        `concept` v_admitting_source_concept 
            ON visit.admitting_source_concept_id = v_admitting_source_concept.concept_id 
    LEFT JOIN
        `concept` v_discharge 
            ON visit.discharge_to_concept_id = v_discharge.concept_id 
    WHERE
        (
            visit_source_concept_id IN (42627988)
        )  
        AND (
            visit.PERSON_ID IN (SELECT
                distinct person_id  
            FROM
                `cb_search_person` cb_search_person  
            WHERE
                cb_search_person.person_id IN (SELECT
                    criteria.person_id 
                FROM
                    (SELECT
                        DISTINCT person_id, entry_date, concept_id 
                    FROM
                        `cb_search_all_events` 
                    WHERE
                        (concept_id IN(SELECT
                            DISTINCT c.concept_id 
                        FROM
                            `cb_criteria` c 
                        JOIN
                            (SELECT
                                CAST(cr.id as string) AS id       
                            FROM
                                `cb_criteria` cr       
                            WHERE
                                concept_id IN (44819543, 1568415, 35207238, 44827678, 1569071, 35225282, 1576172, 44832361, 45563315, 44828872, 1576239, 44827366, 44822999, 44837827, 1569075, 1576311, 1568407, 44823473, 44824618, 1568908, 35207243, 1568408, 44823020, 35207242, 44833491, 1576291, 44823838, 35207240, 44828852, 1568262, 1568412, 35207239, 44833401, 35207241)       
                                AND full_text LIKE '%_rank1]%'      ) a 
                                ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                                OR c.path LIKE CONCAT('%.', a.id) 
                                OR c.path LIKE CONCAT(a.id, '.%') 
                                OR c.path = a.id) 
                        WHERE
                            is_standard = 0 
                            AND is_selectable = 1) 
                        AND is_standard = 0 )) criteria 
                UNION
                DISTINCT SELECT
                    criteria.person_id 
                FROM
                    (SELECT
                        DISTINCT person_id, entry_date, concept_id 
                    FROM
                        `cb_search_all_events` 
                    WHERE
                        (concept_id IN (927179, 927186, 927180, 2314299, 927182, 927181, 927183, 2314297, 2314312, 927184) 
                        AND is_standard = 0 )) criteria 
                UNION
                DISTINCT SELECT
                    criteria.person_id 
                FROM
                    (SELECT
                        DISTINCT person_id, entry_date, concept_id 
                    FROM
                        `cb_search_all_events` 
                    WHERE
                        (concept_id IN (2720162, 2720060, 2720074, 2720152, 2720359, 2720313, 2720427, 2720381, 2720479, 40660167, 2719999, 2719992, 44786598, 2720063, 2720141, 2720455, 2719976, 2720086, 40662114, 44786597, 2720369, 2720466, 2720123, 44782259, 2720422, 2720091, 2720383, 2616864, 2720138, 2720434, 2720257, 2720481, 2720259, 2720456, 2720164, 2720169, 2720096, 2720005, 2720024, 44782268, 2720217, 2720450, 2720044, 2720432, 2720136, 2720392, 2720127, 2719988, 2720436, 2720049, 2720046, 2720425, 2720470, 44782254, 2719971, 44782262, 44782255, 2720124, 2720438, 43533236, 2720131, 2720082, 40217612, 2720135, 2720065, 2720331, 2720476, 2720236, 2720458, 2720089, 2720027, 2720448, 2720417, 2720443, 43533220, 2720094, 2720382, 2720480, 2720137, 2720413, 2720154, 2720462, 2720110, 2720026, 44782253, 44782258, 2720230, 2720168, 40664531, 2720461, 2616774, 2720232, 953198, 2720156, 2720379, 2720358, 2720143, 937587, 2720431, 2720449, 44782264, 2720075, 2720223, 2720467, 915813,
 2720447, 2720031, 40662117, 2720035, 2720395, 2719973, 2720429, 2720416, 2720370, 2720368, 2720414, 2720023, 2720384, 2720095, 2720442, 2720474, 2720377, 2720482, 2720158, 2719980, 2720052, 2720231, 2720468, 2720233, 2720151, 2720386, 2720419, 2720256, 2720248, 2720018, 2720314, 2720420, 2720025, 2720002, 2720139, 2720029, 2720355, 2720444, 2719974, 2720007, 40664738, 2720126, 2720453, 2720465, 2720378, 2720463, 2720235, 2720092, 2720475, 2720273, 2720428, 2720396, 2720171, 2720464, 2720030, 2720012, 2720042, 2720108, 2720132, 2720469, 2719997, 2720385, 2720478, 2720130, 2720001, 2720048, 2720363, 2720150, 2719994, 2720224, 2720047, 2720437, 2720066, 2720435, 44782263, 2720366, 2720040, 2720421, 2720155, 2720068, 2720161, 2720418, 2720483, 2720354, 2720020, 2720090, 2720472, 2720117, 2720142, 2720144, 2720009, 2720423, 2720133, 2720125, 2720019, 2720446, 2720078, 2720160, 2720451, 2720208, 2720317, 2720028, 2720118, 2720240, 2720140, 2720315, 2720179, 2720454, 44782257, 2720477,
 2720239, 44782256, 2720083, 44782265, 2720081, 2616718, 2720080, 2720112, 2720056, 2720342, 2720149, 2720051, 2720061, 2720433, 2720216, 2720146, 44782266, 2720441, 40218592, 2720218, 2720424, 44782249, 2720445, 2720076, 44782260, 2720045) 
                        AND is_standard = 1 )) criteria ) )
            )", sep="")

# Formulate a Cloud Storage destination path for the data exported from BigQuery.
# NOTE: By default data exported multiple times on the same day will overwrite older copies.
#       But data exported on a different days will write to a new location so that historical
#       copies can be kept as the dataset definition is changed.
visit_34437487_path <- file.path(
  Sys.getenv("WORKSPACE_BUCKET"),
  "bq_exports",
  Sys.getenv("OWNER_EMAIL"),
  strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
  "visit_34437487",
  "visit_34437487_*.csv")
message(str_glue('The data will be written to {visit_34437487_path}. Use this path when reading ',
                 'the data into your notebooks in the future.'))

# Perform the query and export the dataset to Cloud Storage as CSV files.
# NOTE: You only need to run `bq_table_save` once. After that, you can
#       just read data from the CSVs in Cloud Storage.
bq_table_save(
  bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_34437487_visit_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
  visit_34437487_path,
  destination_format = "CSV")


# Read the data directly from Cloud Storage into memory.
# NOTE: Alternatively you can `gsutil -m cp {visit_34437487_path}` to copy these files
#       to the Jupyter disk.
read_bq_export_from_workspace_bucket <- function(export_path) {
  col_types <- cols(standard_concept_name = col_character(), standard_concept_code = col_character(), standard_vocabulary = col_character(), visit_type_concept_name = col_character(), visit_source_value = col_character(), source_concept_name = col_character(), source_concept_code = col_character(), source_vocabulary = col_character(), admitting_source_concept_name = col_character(), admitting_source_value = col_character(), discharge_to_concept_name = col_character(), discharge_to_source_value = col_character())
  bind_rows(
    map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
        function(csv) {
          message(str_glue('Loading {csv}.'))
          chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
          if (is.null(col_types)) {
            col_types <- spec(chunk)
          }
          chunk
        }))
}
dataset_34437487_visit_df <- read_bq_export_from_workspace_bucket(visit_34437487_path)

dim(dataset_34437487_visit_df)

head(dataset_34437487_visit_df, 5)
library(tidyverse)
library(bigrquery)

# This query represents dataset "disability_carecascade" for domain "person" and was generated for All of Us Registered Tier Dataset v8
dataset_34437487_person_sql <- paste("
    SELECT
        person.person_id,
        p_gender_concept.concept_name as gender,
        person.birth_datetime as date_of_birth,
        p_race_concept.concept_name as race,
        p_ethnicity_concept.concept_name as ethnicity,
        p_sex_at_birth_concept.concept_name as sex_at_birth,
        p_self_reported_category_concept.concept_name as self_reported_category 
    FROM
        `person` person 
    LEFT JOIN
        `concept` p_gender_concept 
            ON person.gender_concept_id = p_gender_concept.concept_id 
    LEFT JOIN
        `concept` p_race_concept 
            ON person.race_concept_id = p_race_concept.concept_id 
    LEFT JOIN
        `concept` p_ethnicity_concept 
            ON person.ethnicity_concept_id = p_ethnicity_concept.concept_id 
    LEFT JOIN
        `concept` p_sex_at_birth_concept 
            ON person.sex_at_birth_concept_id = p_sex_at_birth_concept.concept_id 
    LEFT JOIN
        `concept` p_self_reported_category_concept 
            ON person.self_reported_category_concept_id = p_self_reported_category_concept.concept_id  
    WHERE
        person.PERSON_ID IN (SELECT
            distinct person_id  
        FROM
            `cb_search_person` cb_search_person  
        WHERE
            cb_search_person.person_id IN (SELECT
                criteria.person_id 
            FROM
                (SELECT
                    DISTINCT person_id, entry_date, concept_id 
                FROM
                    `cb_search_all_events` 
                WHERE
                    (concept_id IN(SELECT
                        DISTINCT c.concept_id 
                    FROM
                        `cb_criteria` c 
                    JOIN
                        (SELECT
                            CAST(cr.id as string) AS id       
                        FROM
                            `cb_criteria` cr       
                        WHERE
                            concept_id IN (44819543, 1568415, 35207238, 44827678, 1569071, 35225282, 1576172, 44832361, 45563315, 44828872, 1576239, 44827366, 44822999, 44837827, 1569075, 1576311, 1568407, 44823473, 44824618, 1568908, 35207243, 1568408, 44823020, 35207242, 44833491, 1576291, 44823838, 35207240, 44828852, 1568262, 1568412, 35207239, 44833401, 35207241)       
                            AND full_text LIKE '%_rank1]%'      ) a 
                            ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                            OR c.path LIKE CONCAT('%.', a.id) 
                            OR c.path LIKE CONCAT(a.id, '.%') 
                            OR c.path = a.id) 
                    WHERE
                        is_standard = 0 
                        AND is_selectable = 1) 
                    AND is_standard = 0 )) criteria 
            UNION
            DISTINCT SELECT
                criteria.person_id 
            FROM
                (SELECT
                    DISTINCT person_id, entry_date, concept_id 
                FROM
                    `cb_search_all_events` 
                WHERE
                    (concept_id IN (927179, 927186, 927180, 2314299, 927182, 927181, 927183, 2314297, 2314312, 927184) 
                    AND is_standard = 0 )) criteria 
            UNION
            DISTINCT SELECT
                criteria.person_id 
            FROM
                (SELECT
                    DISTINCT person_id, entry_date, concept_id 
                FROM
                    `cb_search_all_events` 
                WHERE
                    (concept_id IN (2720162, 2720060, 2720074, 2720152, 2720359, 2720313, 2720427, 2720381, 2720479, 40660167, 2719999, 2719992, 44786598, 2720063, 2720141, 2720455, 2719976, 2720086, 40662114, 44786597, 2720369, 2720466, 2720123, 44782259, 2720422, 2720091, 2720383, 2616864, 2720138, 2720434, 2720257, 2720481, 2720259, 2720456, 2720164, 2720169, 2720096, 2720005, 2720024, 44782268, 2720217, 2720450, 2720044, 2720432, 2720136, 2720392, 2720127, 2719988, 2720436, 2720049, 2720046, 2720425, 2720470, 44782254, 2719971, 44782262, 44782255, 2720124, 2720438, 43533236, 2720131, 2720082, 40217612, 2720135, 2720065, 2720331, 2720476, 2720236, 2720458, 2720089, 2720027, 2720448, 2720417, 2720443, 43533220, 2720094, 2720382, 2720480, 2720137, 2720413, 2720154, 2720462, 2720110, 2720026, 44782253, 44782258, 2720230, 2720168, 40664531, 2720461, 2616774, 2720232, 953198, 2720156, 2720379, 2720358, 2720143, 937587, 2720431, 2720449, 44782264, 2720075, 2720223, 2720467, 915813,
 2720447, 2720031, 40662117, 2720035, 2720395, 2719973, 2720429, 2720416, 2720370, 2720368, 2720414, 2720023, 2720384, 2720095, 2720442, 2720474, 2720377, 2720482, 2720158, 2719980, 2720052, 2720231, 2720468, 2720233, 2720151, 2720386, 2720419, 2720256, 2720248, 2720018, 2720314, 2720420, 2720025, 2720002, 2720139, 2720029, 2720355, 2720444, 2719974, 2720007, 40664738, 2720126, 2720453, 2720465, 2720378, 2720463, 2720235, 2720092, 2720475, 2720273, 2720428, 2720396, 2720171, 2720464, 2720030, 2720012, 2720042, 2720108, 2720132, 2720469, 2719997, 2720385, 2720478, 2720130, 2720001, 2720048, 2720363, 2720150, 2719994, 2720224, 2720047, 2720437, 2720066, 2720435, 44782263, 2720366, 2720040, 2720421, 2720155, 2720068, 2720161, 2720418, 2720483, 2720354, 2720020, 2720090, 2720472, 2720117, 2720142, 2720144, 2720009, 2720423, 2720133, 2720125, 2720019, 2720446, 2720078, 2720160, 2720451, 2720208, 2720317, 2720028, 2720118, 2720240, 2720140, 2720315, 2720179, 2720454, 44782257, 2720477,
 2720239, 44782256, 2720083, 44782265, 2720081, 2616718, 2720080, 2720112, 2720056, 2720342, 2720149, 2720051, 2720061, 2720433, 2720216, 2720146, 44782266, 2720441, 40218592, 2720218, 2720424, 44782249, 2720445, 2720076, 44782260, 2720045) 
                    AND is_standard = 1 )) criteria ) )", sep="")

# Formulate a Cloud Storage destination path for the data exported from BigQuery.
# NOTE: By default data exported multiple times on the same day will overwrite older copies.
#       But data exported on a different days will write to a new location so that historical
#       copies can be kept as the dataset definition is changed.
person_34437487_path <- file.path(
  Sys.getenv("WORKSPACE_BUCKET"),
  "bq_exports",
  Sys.getenv("OWNER_EMAIL"),
  strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
  "person_34437487",
  "person_34437487_*.csv")
message(str_glue('The data will be written to {person_34437487_path}. Use this path when reading ',
                 'the data into your notebooks in the future.'))

# Perform the query and export the dataset to Cloud Storage as CSV files.
# NOTE: You only need to run `bq_table_save` once. After that, you can
#       just read data from the CSVs in Cloud Storage.
bq_table_save(
  bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_34437487_person_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
  person_34437487_path,
  destination_format = "CSV")


# Read the data directly from Cloud Storage into memory.
# NOTE: Alternatively you can `gsutil -m cp {person_34437487_path}` to copy these files
#       to the Jupyter disk.
read_bq_export_from_workspace_bucket <- function(export_path) {
  col_types <- cols(gender = col_character(), race = col_character(), ethnicity = col_character(), sex_at_birth = col_character(), self_reported_category = col_character())
  bind_rows(
    map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
        function(csv) {
          message(str_glue('Loading {csv}.'))
          chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
          if (is.null(col_types)) {
            col_types <- spec(chunk)
          }
          chunk
        }))
}
dataset_34437487_person_df <- read_bq_export_from_workspace_bucket(person_34437487_path)

dim(dataset_34437487_person_df)

head(dataset_34437487_person_df, 5)
library(tidyverse)
library(bigrquery)

# This query represents dataset "disability_carecascade" for domain "device" and was generated for All of Us Registered Tier Dataset v8
dataset_34437487_device_sql <- paste("
    SELECT
        device.person_id,
        device.device_concept_id,
        d_standard_concept.concept_name as standard_concept_name,
        d_standard_concept.concept_code as standard_concept_code,
        d_standard_concept.vocabulary_id as standard_vocabulary,
        device.device_exposure_start_datetime,
        device.device_exposure_end_datetime,
        device.device_type_concept_id,
        d_type.concept_name as device_type_concept_name,
        device.visit_occurrence_id,
        visit.concept_name as visit_occurrence_concept_name,
        device.device_source_value,
        device.device_source_concept_id,
        d_source_concept.concept_name as source_concept_name,
        d_source_concept.concept_code as source_concept_code,
        d_source_concept.vocabulary_id as source_vocabulary 
    FROM
        ( SELECT
            * 
        FROM
            `device_exposure` device 
        WHERE
            (
                device_concept_id IN (2616718, 2616774, 2616864, 2719971, 2719973, 2719974, 2719976, 2719980, 2719988, 2719992, 2719994, 2719997, 2719999, 2720001, 2720002, 2720005, 2720007, 2720009, 2720012, 2720018, 2720019, 2720020, 2720023, 2720024, 2720025, 2720026, 2720027, 2720028, 2720029, 2720030, 2720031, 2720035, 2720040, 2720042, 2720044, 2720045, 2720046, 2720047, 2720048, 2720049, 2720051, 2720052, 2720056, 2720060, 2720061, 2720063, 2720065, 2720066, 2720068, 2720074, 2720075, 2720076, 2720078, 2720080, 2720081, 2720082, 2720083, 2720086, 2720089, 2720090, 2720091, 2720092, 2720094, 2720095, 2720096, 2720108, 2720110, 2720112, 2720117, 2720118, 2720123, 2720124, 2720125, 2720126, 2720127, 2720130, 2720131, 2720132, 2720133, 2720135, 2720136, 2720137, 2720138, 2720139, 2720140, 2720141, 2720142, 2720143, 2720144, 2720146, 2720149, 2720150, 2720151, 2720152, 2720154, 2720155, 2720156, 2720158, 2720160, 2720161, 2720162, 2720164, 2720168, 2720169, 2720171, 2720179, 2720208,
 2720216, 2720217, 2720218, 2720223, 2720224, 2720230, 2720231, 2720232, 2720233, 2720235, 2720236, 2720239, 2720240, 2720248, 2720256, 2720257, 2720259, 2720273, 2720313, 2720314, 2720315, 2720317, 2720331, 2720342, 2720354, 2720355, 2720358, 2720359, 2720363, 2720366, 2720368, 2720369, 2720370, 2720377, 2720378, 2720379, 2720381, 2720382, 2720383, 2720384, 2720385, 2720386, 2720392, 2720395, 2720396, 2720413, 2720414, 2720416, 2720417, 2720418, 2720419, 2720420, 2720421, 2720422, 2720423, 2720424, 2720425, 2720427, 2720428, 2720429, 2720431, 2720432, 2720433, 2720434, 2720435, 2720436, 2720437, 2720438, 2720441, 2720442, 2720443, 2720444, 2720445, 2720446, 2720447, 2720448, 2720449, 2720450, 2720451, 2720453, 2720454, 2720455, 2720456, 2720458, 2720461, 2720462, 2720463, 2720464, 2720465, 2720466, 2720467, 2720468, 2720469, 2720470, 2720472, 2720474, 2720475, 2720476, 2720477, 2720478, 2720479, 2720480, 2720481, 2720482, 2720483, 40217612, 40218592, 40660167, 40662114, 40662117,
 40664531, 40664738, 43533220, 43533236, 44782249, 44782253, 44782254, 44782255, 44782256, 44782257, 44782258, 44782259, 44782260, 44782262, 44782263, 44782264, 44782265, 44782266, 44782268, 44786597, 44786598, 915813, 937587, 953198)
            )  
            AND (
                PERSON_ID IN (SELECT
                    distinct person_id  
                FROM
                    `cb_search_person` cb_search_person  
                WHERE
                    cb_search_person.person_id IN (SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN(SELECT
                                DISTINCT c.concept_id 
                            FROM
                                `cb_criteria` c 
                            JOIN
                                (SELECT
                                    CAST(cr.id as string) AS id       
                                FROM
                                    `cb_criteria` cr       
                                WHERE
                                    concept_id IN (44819543, 1568415, 35207238, 44827678, 1569071, 35225282, 1576172, 44832361, 45563315, 44828872, 1576239, 44827366, 44822999, 44837827, 1569075, 1576311, 1568407, 44823473, 44824618, 1568908, 35207243, 1568408, 44823020, 35207242, 44833491, 1576291, 44823838, 35207240, 44828852, 1568262, 1568412, 35207239, 44833401, 35207241)       
                                    AND full_text LIKE '%_rank1]%'      ) a 
                                    ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                                    OR c.path LIKE CONCAT('%.', a.id) 
                                    OR c.path LIKE CONCAT(a.id, '.%') 
                                    OR c.path = a.id) 
                            WHERE
                                is_standard = 0 
                                AND is_selectable = 1) 
                            AND is_standard = 0 )) criteria 
                    UNION
                    DISTINCT SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN (927179, 927186, 927180, 2314299, 927182, 927181, 927183, 2314297, 2314312, 927184) 
                            AND is_standard = 0 )) criteria 
                    UNION
                    DISTINCT SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN (2720162, 2720060, 2720074, 2720152, 2720359, 2720313, 2720427, 2720381, 2720479, 40660167, 2719999, 2719992, 44786598, 2720063, 2720141, 2720455, 2719976, 2720086, 40662114, 44786597, 2720369, 2720466, 2720123, 44782259, 2720422, 2720091, 2720383, 2616864, 2720138, 2720434, 2720257, 2720481, 2720259, 2720456, 2720164, 2720169, 2720096, 2720005, 2720024, 44782268, 2720217, 2720450, 2720044, 2720432, 2720136, 2720392, 2720127, 2719988, 2720436, 2720049, 2720046, 2720425, 2720470, 44782254, 2719971, 44782262, 44782255, 2720124, 2720438, 43533236, 2720131, 2720082, 40217612, 2720135, 2720065, 2720331, 2720476, 2720236, 2720458, 2720089, 2720027, 2720448, 2720417, 2720443, 43533220, 2720094, 2720382, 2720480, 2720137, 2720413, 2720154, 2720462, 2720110, 2720026, 44782253, 44782258, 2720230, 2720168, 40664531, 2720461, 2616774, 2720232, 953198, 2720156, 2720379, 2720358, 2720143, 937587, 2720431, 2720449, 44782264, 2720075, 2720223, 2720467, 915813,
 2720447, 2720031, 40662117, 2720035, 2720395, 2719973, 2720429, 2720416, 2720370, 2720368, 2720414, 2720023, 2720384, 2720095, 2720442, 2720474, 2720377, 2720482, 2720158, 2719980, 2720052, 2720231, 2720468, 2720233, 2720151, 2720386, 2720419, 2720256, 2720248, 2720018, 2720314, 2720420, 2720025, 2720002, 2720139, 2720029, 2720355, 2720444, 2719974, 2720007, 40664738, 2720126, 2720453, 2720465, 2720378, 2720463, 2720235, 2720092, 2720475, 2720273, 2720428, 2720396, 2720171, 2720464, 2720030, 2720012, 2720042, 2720108, 2720132, 2720469, 2719997, 2720385, 2720478, 2720130, 2720001, 2720048, 2720363, 2720150, 2719994, 2720224, 2720047, 2720437, 2720066, 2720435, 44782263, 2720366, 2720040, 2720421, 2720155, 2720068, 2720161, 2720418, 2720483, 2720354, 2720020, 2720090, 2720472, 2720117, 2720142, 2720144, 2720009, 2720423, 2720133, 2720125, 2720019, 2720446, 2720078, 2720160, 2720451, 2720208, 2720317, 2720028, 2720118, 2720240, 2720140, 2720315, 2720179, 2720454, 44782257, 2720477,
 2720239, 44782256, 2720083, 44782265, 2720081, 2616718, 2720080, 2720112, 2720056, 2720342, 2720149, 2720051, 2720061, 2720433, 2720216, 2720146, 44782266, 2720441, 40218592, 2720218, 2720424, 44782249, 2720445, 2720076, 44782260, 2720045) 
                            AND is_standard = 1 )) criteria ) )
                )
            ) device 
        LEFT JOIN
            `concept` d_standard_concept 
                ON device.device_concept_id = d_standard_concept.concept_id 
        LEFT JOIN
            `concept` d_type 
                ON device.device_type_concept_id = d_type.concept_id 
        LEFT JOIN
            `visit_occurrence` v 
                ON device.visit_occurrence_id = v.visit_occurrence_id 
        LEFT JOIN
            `concept` visit 
                ON v.visit_concept_id = visit.concept_id 
        LEFT JOIN
            `concept` d_source_concept 
                ON device.device_source_concept_id = d_source_concept.concept_id", sep="")

# Formulate a Cloud Storage destination path for the data exported from BigQuery.
# NOTE: By default data exported multiple times on the same day will overwrite older copies.
#       But data exported on a different days will write to a new location so that historical
#       copies can be kept as the dataset definition is changed.
device_34437487_path <- file.path(
  Sys.getenv("WORKSPACE_BUCKET"),
  "bq_exports",
  Sys.getenv("OWNER_EMAIL"),
  strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
  "device_34437487",
  "device_34437487_*.csv")
message(str_glue('The data will be written to {device_34437487_path}. Use this path when reading ',
                 'the data into your notebooks in the future.'))

# Perform the query and export the dataset to Cloud Storage as CSV files.
# NOTE: You only need to run `bq_table_save` once. After that, you can
#       just read data from the CSVs in Cloud Storage.
bq_table_save(
  bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_34437487_device_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
  device_34437487_path,
  destination_format = "CSV")


# Read the data directly from Cloud Storage into memory.
# NOTE: Alternatively you can `gsutil -m cp {device_34437487_path}` to copy these files
#       to the Jupyter disk.
read_bq_export_from_workspace_bucket <- function(export_path) {
  col_types <- cols(standard_concept_name = col_character(), standard_concept_code = col_character(), standard_vocabulary = col_character(), device_type_concept_name = col_character(), visit_occurrence_concept_name = col_character(), device_source_value = col_character(), source_concept_name = col_character(), source_concept_code = col_character(), source_vocabulary = col_character())
  bind_rows(
    map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
        function(csv) {
          message(str_glue('Loading {csv}.'))
          chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
          if (is.null(col_types)) {
            col_types <- spec(chunk)
          }
          chunk
        }))
}
dataset_34437487_device_df <- read_bq_export_from_workspace_bucket(device_34437487_path)

dim(dataset_34437487_device_df)

head(dataset_34437487_device_df, 5)
