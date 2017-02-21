createTableAndFigures<-function(exportFolder, cmOutputFolder){
        outcomeReference <- readRDS(file.path(cmOutputFolder, "outcomeModelReference.rds"))
        analysisSummary <- read.csv(file.path(exportFolder, "MainResults.csv"))
        
        tablesAndFiguresFolder <- file.path(exportFolder, "tablesAndFigures")
        if (!file.exists(tablesAndFiguresFolder))
                dir.create(tablesAndFiguresFolder)
        
        #  negControlCohortIds <- unique(analysisSummary$outcomeId[analysisSummary$outcomeId != 124])
        #  # Calibrate p-values and draw calibration plots:
        #  for (analysisId in unique(analysisSummary$analysisId)) {
        #    negControlSubset <- analysisSummary[analysisSummary$analysisId == analysisId & analysisSummary$outcomeId %in%
        #                                          negControlCohortIds, ]
        #    negControlSubset <- negControlSubset[!is.na(negControlSubset$logRr) & negControlSubset$logRr !=
        #                                           0, ]
        #    if (nrow(negControlSubset) > 10) {
        #      null <- EmpiricalCalibration::fitMcmcNull(negControlSubset$logRr, negControlSubset$seLogRr)
        #      subset <- analysisSummary[analysisSummary$analysisId == analysisId, ]
        #      calibratedP <- EmpiricalCalibration::calibrateP(null, subset$logRr, subset$seLogRr)
        #      subset$calibratedP <- calibratedP$p
        #      subset$calibratedP_lb95ci <- calibratedP$lb95ci
        #      subset$calibratedP_ub95ci <- calibratedP$ub95ci
        #      mcmc <- attr(null, "mcmc")
        #      subset$null_mean <- mean(mcmc$chain[, 1])
        #      subset$null_sd <- 1/sqrt(mean(mcmc$chain[, 2]))
        #      analysisSummary$calibratedP[analysisSummary$analysisId == analysisId] <- subset$calibratedP
        #      analysisSummary$calibratedP_lb95ci[analysisSummary$analysisId == analysisId] <- subset$calibratedP_lb95ci
        #      analysisSummary$calibratedP_ub95ci[analysisSummary$analysisId == analysisId] <- subset$calibratedP_ub95ci
        #      analysisSummary$null_mean[analysisSummary$analysisId == analysisId] <- subset$null_mean
        #      analysisSummary$null_sd[analysisSummary$analysisId == analysisId] <- subset$null_sd
        #      EmpiricalCalibration::plotCalibration(negControlSubset$logRr,
        #                                            negControlSubset$seLogRr,
        #                                            fileName = file.path(tablesAndFiguresFolder,
        #                                                                 paste0("Cal_a", analysisId, ".png")))
        #      EmpiricalCalibration::plotCalibrationEffect(negControlSubset$logRr,
        #                                                  negControlSubset$seLogRr,
        #                                                  fileName = file.path(tablesAndFiguresFolder,
        #                                                                       paste0("CalEffectNoHoi_a", analysisId, ".png")))
        #      hoi <- analysisSummary[analysisSummary$analysisId == analysisId & !(analysisSummary$outcomeId %in%
        #                                                                            negControlCohortIds), ]
        #      EmpiricalCalibration::plotCalibrationEffect(negControlSubset$logRr,
        #                                                  negControlSubset$seLogRr,
        #                                                  hoi$logRr,
        #                                                  hoi$seLogRr,
        #                                                  fileName = file.path(tablesAndFiguresFolder,
        #                                                                       paste0("CalEffect_a", analysisId, ".png")))
        #      EmpiricalCalibration::plotCalibrationEffect(negControlSubset$logRr,
        #                                                  negControlSubset$seLogRr,
        #                                                  hoi$logRr,
        #                                                  hoi$seLogRr,
        #                                                  showCis = TRUE,
        #                                                  fileName = file.path(tablesAndFiguresFolder,
        #                                                                       paste0("CalEffectCi_a", analysisId, ".png")))
        #    }
        #  }
        #  write.csv(analysisSummary, file.path(tablesAndFiguresFolder,
        #                                       "EmpiricalCalibration.csv"), row.names = FALSE)
        
        # Balance plots:
        #  balance <- read.csv(file.path(exportFolder, "Balance1On1Matching.csv"))
        #  CohortMethod::plotCovariateBalanceScatterPlot(balance,
        #                                                fileName = file.path(tablesAndFiguresFolder,
        #                                                                     "BalanceScatterPlot1On1Matching.png"))
        #  CohortMethod::plotCovariateBalanceOfTopVariables(balance,
        #                                                   fileName = file.path(tablesAndFiguresFolder,
        #                                                                        "BalanceTopVariables1On1Matching.png"))
        for(i in 1:135){
                
                idx<-paste0("t",outcomeReference$targetId[i],"_c",outcomeReference$comparatorId[i],"_o",outcomeReference$outcomeId[i])
                balance <- read.csv(file.path(exportFolder, paste0("Balance",idx,".csv")))
                CohortMethod::plotCovariateBalanceScatterPlot(balance,
                                                              fileName = file.path(tablesAndFiguresFolder,
                                                                                   paste0("BalanceScatterPlot",idx,".png")))
                CohortMethod::plotCovariateBalanceOfTopVariables(balance,
                                                                 fileName = file.path(tablesAndFiguresFolder,
                                                                                      paste0("BalanceTopVariables",idx,".png")))
        }
        
        ### Population characteristics table
        #  balance <- read.csv(file.path(exportFolder, "BalanceVarRatioMatching.csv"))
        #  ## Age
        #  age <- balance[grep("Age group:", balance$covariateName), ]
        #  age <- data.frame(group = age$covariateName,
        #                    countTreated = age$beforeMatchingSumTreated,
        #                    countComparator = age$beforeMatchingSumComparator,
        #                    fractionTreated = age$beforeMatchingMeanTreated,
        #                    fractionComparator = age$beforeMatchingMeanComparator)
        #  
        #  # Add removed age group (if any):
        #  removedCovars <- read.csv(file.path(exportFolder, "RemovedCovars.csv"))
        #  removedAgeGroup <- removedCovars[grep("Age group:", removedCovars$covariateName), ]
        #  if (nrow(removedAgeGroup) == 1) {
        #    totalTreated <- age$countTreated[1] / age$fractionTreated[1]
        #    missingFractionTreated <- 1 - sum(age$fractionTreated)
        #    missingFractionComparator <- 1 - sum(age$fractionComparator)
        #    removedAgeGroup <- data.frame(group = removedAgeGroup$covariateName,
        #                                  countTreated = round(missingFractionTreated * totalTreated),
        #                                  countComparator = round(missingFractionComparator * totalTreated),
        #                                  fractionTreated = missingFractionTreated,
        #                                  fractionComparator = missingFractionComparator)
        #    age <- rbind(age, removedAgeGroup)
        #  }
        #  age$start <- gsub("Age group: ", "", gsub("-.*$", "", age$group))
        #  age$start <- as.integer(age$start)
        #  age <- age[order(age$start), ]
        #  age$start <- NULL
        #  
        #  ## Gender
        #  gender <- balance[grep("Gender", balance$covariateName), ]
        #  gender <- data.frame(group = gender$covariateName,
        #                       countTreated = gender$beforeMatchingSumTreated,
        #                       countComparator = gender$beforeMatchingSumComparator,
        #                       fractionTreated = gender$beforeMatchingMeanTreated,
        #                       fractionComparator = gender$beforeMatchingMeanComparator)
        #  # Add removed gender (if any):
        #  removedGender <- removedCovars[grep("Gender", removedCovars$covariateName), ]
        #  if (nrow(removedGender) == 1) {
        #    totalTreated <- gender$countTreated[1] / gender$fractionTreated[1]
        #    missingFractionTreated <- 1 - sum(gender$fractionTreated)
        #    missingFractionComparator <- 1 - sum(gender$fractionComparator)
        #    removedGender <- data.frame(group = removedGender$covariateName,
        #                                countTreated = round(missingFractionTreated * totalTreated),
        #                                countComparator = round(missingFractionComparator * totalTreated),
        #                                fractionTreated = missingFractionTreated,
        #                                fractionComparator = missingFractionComparator)
        #    gender <- rbind(gender, removedGender)
        #  }
        #  gender$group <- gsub("Gender = ", "", gender$group)
        #  
        #  ## Calendar year
        #  year <- balance[grep("Index year", balance$covariateName), ]
        #  year <- data.frame(group = year$covariateName,
        #                     countTreated = year$beforeMatchingSumTreated,
        #                     countComparator = year$beforeMatchingSumComparator,
        #                     fractionTreated = year$beforeMatchingMeanTreated,
        #                     fractionComparator = year$beforeMatchingMeanComparator)
        #  # Add removed year (if any):
        #  removedYear <- removedCovars[grep("Index year", removedCovars$covariateName), ]
        #  if (nrow(removedYear) == 1) {
        #    totalTreated <- year$countTreated[1] / year$fractionTreated[1]
        #    missingFractionTreated <- 1 - sum(year$fractionTreated)
        #    missingFractionComparator <- 1 - sum(year$fractionComparator)
        #    removedYear <- data.frame(group = removedYear$covariateName,
        #                              countTreated = round(missingFractionTreated * totalTreated),
        #                              countComparator = round(missingFractionComparator * totalTreated),
        #                              fractionTreated = missingFractionTreated,
        #                              fractionComparator = missingFractionComparator)
        #    year <- rbind(year, removedYear)
        #  }
        #  year$group <- gsub("Index year: ", "", year$group)
        #  year <- year[order(year$group), ]
        #  
        #  table <- rbind(age, gender, year)
        #  write.csv(table, file.path(tablesAndFiguresFolder, "PopChar.csv"), row.names = FALSE)
        
        for(i in 1:135){
                idx<-paste0("t",outcomeReference$targetId[i],"_c",outcomeReference$comparatorId[i],"_o",outcomeReference$outcomeId[i])
                balance <- read.csv(file.path(exportFolder, paste0("Balance",idx,".csv")))
                attrition <- read.csv(file.path(exportFolder, paste0("AttritionTable",idx,".csv")))
                ## Age
                
                age <- balance[grep("Age group:", balance$covariateName), ]
                age <- data.frame(group = age$covariateName,
                                  beforecountTreated = age$beforeMatchingSumTreated,
                                  beforecountComparator = age$beforeMatchingSumComparator,
                                  beforefractionTreated = age$beforeMatchingMeanTreated,
                                  beforefractionComparator = age$beforeMatchingMeanComparator,
                                  aftercountTreated = age$afterMatchingSumTreated,
                                  aftercountComparator = age$afterMatchingSumComparator,
                                  afterfractionTreated = age$afterMatchingMeanTreated,
                                  afterfractionComparator = age$afterMatchingMeanComparator
                                  )
                
                # Add removed age group (if any):
                removedCovars <- read.csv(file.path(exportFolder, paste0("RemovedCovars",idx,".csv")))
                removedAgeGroup <- removedCovars[grep("Age group:", removedCovars$covariateName), ]
                try(
                if (nrow(removedAgeGroup) == 1) {
                        beforetotalTreated <- age$beforecountTreated[1] / age$beforefractionTreated[1]
                        beforemissingFractionTreated <- 1 - sum(age$beforefractionTreated)
                        beforemissingFractionComparator <- 1 - sum(age$beforefractionComparator)
                        
                        aftertotalTreated <- age$aftercountTreated[1] / age$afterfractionTreated[1]
                        aftermissingFractionTreated <- 1 - sum(age$afterfractionTreated)
                        aftermissingFractionComparator <- 1 - sum(age$afterfractionComparator)
                        
                        removedAgeGroup <- data.frame(group = removedAgeGroup$covariateName,
                                                    beforecountTreated = round(beforemissingFractionTreated * beforetotalTreated),
                                                    beforecountComparator = round(beforemissingFractionComparator * beforetotalTreated),
                                                    beforefractionTreated = beforemissingFractionTreated,
                                                    beforefractionComparator = beforemissingFractionComparator,
                                                    aftercountTreated = round(aftermissingFractionTreated * aftertotalTreated),
                                                    aftercountComparator = round(aftermissingFractionComparator * aftertotalTreated),
                                                    afterfractionTreated = aftermissingFractionTreated,
                                                    afterfractionComparator = aftermissingFractionComparator)
                        age <- rbind(age, removedAgeGroup)
                }
                )
                age$start <- gsub("Age group: ", "", gsub("-.*$", "", age$group))
                age$start <- as.integer(age$start)
                age <- age[order(age$start), ]
                age$start <- NULL
                
                ## Gender
                gender <- balance[grep("Gender", balance$covariateName), ]
                gender <- data.frame(group = gender$covariateName,
                                     beforecountTreated = gender$beforeMatchingSumTreated,
                                     beforecountComparator = gender$beforeMatchingSumComparator,
                                     beforefractionTreated = gender$beforeMatchingMeanTreated,
                                     beforefractionComparator = gender$beforeMatchingMeanComparator,
                                     aftercountTreated = gender$afterMatchingSumTreated,
                                     aftercountComparator = gender$afterMatchingSumComparator,
                                     afterfractionTreated = gender$afterMatchingMeanTreated,
                                     afterfractionComparator = gender$afterMatchingMeanComparator)
                # Add removed gender (if any):
                removedGender <- removedCovars[grep("Gender", removedCovars$covariateName), ]
                try(
                if (nrow(removedGender) == 1) {
                        beforetotalTreated <- gender$beforecountTreated[1] / gender$beforefractionTreated[1]
                        beforemissingFractionTreated <- 1 - sum(gender$beforefractionTreated)
                        beforemissingFractionComparator <- 1 - sum(gender$beforefractionComparator)
                        
                        aftertotalTreated <- age$aftercountTreated[1] / gender$afterfractionTreated[1]
                        aftermissingFractionTreated <- 1 - sum(gender$afterfractionTreated)
                        aftermissingFractionComparator <- 1 - sum(gender$afterfractionComparator)
                        
                        removedGender <- data.frame(group = removedGender$covariateName,
                                                    beforecountTreated = round(beforemissingFractionTreated * beforetotalTreated),
                                                    beforecountComparator = round(beforemissingFractionComparator * beforetotalTreated),
                                                    beforefractionTreated = beforemissingFractionTreated,
                                                    beforefractionComparator = beforemissingFractionComparator,
                                                    aftercountTreated = round(aftermissingFractionTreated * aftertotalTreated),
                                                    aftercountComparator = round(aftermissingFractionComparator * aftertotalTreated),
                                                    afterfractionTreated = aftermissingFractionTreated,
                                                    afterfractionComparator = aftermissingFractionComparator)
                        gender <- rbind(gender, removedGender)
                }
                )
                gender$group <- gsub("Gender = ", "", gender$group)
                
                ## Calendar year
                year <- balance[grep("Index year", balance$covariateName), ]
                
                year <- data.frame(group = year$covariateName,
                                  beforecountTreated = year$beforeMatchingSumTreated,
                                  beforecountComparator = year$beforeMatchingSumComparator,
                                  beforefractionTreated = year$beforeMatchingMeanTreated,
                                  beforefractionComparator = year$beforeMatchingMeanComparator,
                                  aftercountTreated = year$afterMatchingSumTreated,
                                  aftercountComparator = year$afterMatchingSumComparator,
                                  afterfractionTreated = year$afterMatchingMeanTreated,
                                  afterfractionComparator = year$afterMatchingMeanComparator)
                
                # Add removed year (if any):
                removedYear <- removedCovars[grep("Index year", removedCovars$covariateName), ]
                try(
                if (nrow(removedYear) == 1) {
                        beforetotalTreated <- year$beforecountTreated[1] / year$beforefractionTreated[1]
                        beforemissingFractionTreated <- 1 - sum(year$beforefractionTreated)
                        beforemissingFractionComparator <- 1 - sum(year$beforefractionComparator)
                        
                        aftertotalTreated <- year$aftercountTreated[1] / year$afterfractionTreated[1]
                        aftermissingFractionTreated <- 1 - sum(year$afterfractionTreated)
                        aftermissingFractionComparator <- 1 - sum(year$afterfractionComparator)
                        
                        removedYear <- data.frame(group = removedYear$covariateName,
                                                    beforecountTreated = round(beforemissingFractionTreated * beforetotalTreated),
                                                    beforecountComparator = round(beforemissingFractionComparator * beforetotalTreated),
                                                    beforefractionTreated = beforemissingFractionTreated,
                                                    beforefractionComparator = beforemissingFractionComparator,
                                                    aftercountTreated = round(aftermissingFractionTreated * aftertotalTreated),
                                                    aftercountComparator = round(aftermissingFractionComparator * aftertotalTreated),
                                                    afterfractionTreated = aftermissingFractionTreated,
                                                    afterfractionComparator = aftermissingFractionComparator)
                        year <- rbind(year, removedYear)
                }
                )
                year$group <- gsub("Index year: ", "", year$group)
                year <- year[order(year$group), ]
                
                table <- rbind(age, gender, year)
                write.csv(table, file.path(tablesAndFiguresFolder, paste0("PopChar",idx,".csv")), row.names = FALSE)
        }
        
        
        
        ### Attrition diagrams
        #  attrition <- read.csv(file.path(exportFolder, "Attrition1On1Matching.csv"))
        #  object <- list()
        #  attr(object, "metaData") <- list(attrition = attrition)
        #  CohortMethod::drawAttritionDiagram(object, fileName = file.path(tablesAndFiguresFolder, "Attr1On1Matching.png"))
        #  
        #  attrition <- read.csv(file.path(exportFolder, "AttritionVarRatioMatching.csv"))
        #  object <- list()
        #  attr(object, "metaData") <- list(attrition = attrition)
        #  CohortMethod::drawAttritionDiagram(object, fileName = file.path(tablesAndFiguresFolder, "AttrVarRatioMatching.png"))
        
        for(i in 1:135){
                idx<-paste0("t",outcomeReference$targetId[i],"_c",outcomeReference$comparatorId[i],"_o",outcomeReference$outcomeId[i])
                attrition <- read.csv(file.path(exportFolder, paste0("AttritionTable",idx,".csv")))
                object <- list()
                attr(object, "metaData") <- list(attrition = attrition)
                CohortMethod::drawAttritionDiagram(object, fileName = file.path(tablesAndFiguresFolder, paste0("Attrition",idx,".png")))
        }
        
}