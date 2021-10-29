-- *******************************************************************
--
-- Initialize empty Drugs@FDA database, using table format defined at:
-- https://www.fda.gov/drugs/drug-approvals-and-databases/drugsfda-data-files
--
-- *******************************************************************

-- Application Documents (ApplicationDocs):
-- Document addresses or URLs to letters, labels, reviews,
-- Consumer Information Sheets, FDA Talk Papers, and other types.
CREATE TABLE ApplicationDocs (
    ApplicationDocsID INTEGER NOT NULL,
    ApplicationDocsTypeID INTEGER NOT NULL,
    ApplNo VARCHAR(6) NOT NULL,
    SubmissionType VARCHAR(10) NOT NULL,
    SubmissionNo INTEGER NOT NULL,
    ApplicationDocsTitle VARCHAR(100) NULL,
    ApplicationDocsURL VARCHAR(200) NULL,
    ApplicationDocsDate DATE NULL,
    PRIMARY KEY(ApplicationDocsID)
);

-- Application Document Type Lookup (ApplicationsDocsType_Lookup):
-- Type of document that is linked, which relates to the AppDoc table.
CREATE TABLE ApplicationsDocsType_Lookup (
    ApplicationDocsType_Lookup_ID INTEGER NOT NULL,
    ApplicationDocsType_Lookup_Description VARCHAR(200) NOT NULL,
    PRIMARY KEY(ApplicationDocsType_Lookup_ID)
);

-- Applications (Applications):
-- Application number and sponsor name.
CREATE TABLE Applications (
    ApplNo VARCHAR(6) NOT NULL,
    ApplType VARCHAR(5) NOT NULL,
    ApplPublicNotes TEXT NULL,
    SponsorName VARCHAR(500) NULL
);

-- Products (Products):
-- This table contains the products included in each application.
-- Includes form, dosage, and route.
CREATE TABLE Products (
    ApplNo VARCHAR(6) NOT NULL,
    ProductNo VARCHAR(6) NOT NULL,
    Form VARCHAR(255) NULL,
    Strength VARCHAR(240) NULL,
    ReferenceDrug INTEGER NULL,
    DrugName VARCHAR(125) NULL,
    ActiveIngredient VARCHAR(255) NULL,
    ReferenceStandard INTEGER NULL
);

-- TE: Therapeutic Equivalence Code for Products.
CREATE TABLE TE (
    ApplNo VARCHAR(6) NOT NULL,
    ProductNo VARCHAR(3) NOT NULL,
    MarketingStatusID INTEGER NOT NULL,
    TECode VARCHAR(100) NOT NULL
);

-- Further tables and view:
CREATE TABLE ActionTypes_Lookup (
    ActionTypes_LookupID INTEGER NOT NULL,
    ActionTypes_LookupDescription VARCHAR(100) NOT NULL,
    SupplCategoryLevel1Code VARCHAR(100) NULL,
    SupplCategoryLevel2Code VARCHAR(100) NULL,
    PRIMARY KEY(ActionTypes_LookupID)
);

CREATE TABLE MarketingStatus (
    MarketingStatusID INTEGER NOT NULL,
    ApplNo VARCHAR(6) NOT NULL,
    ProductNo VARCHAR(3) NOT NULL
);

CREATE TABLE MarketingStatus_Lookup (
    MarketingStatusID INTEGER NOT NULL,
    MarketingStatusDescription VARCHAR(200) NOT NULL,
    PRIMARY KEY(MarketingStatusID)
);

CREATE TABLE SubmissionClass_Lookup (
    SubmissionClassCodeID INTEGER NOT NULL,
    SubmissionClassCode VARCHAR(50) NOT NULL,
    SubmissionClassCodeDescription VARCHAR(500) NULL,
    PRIMARY KEY(SubmissionClassCodeID)
);

CREATE TABLE SubmissionPropertyType (
    ApplNo VARCHAR(6) NOT NULL,
    SubmissionType VARCHAR(10) NOT NULL,
    SubmissionNo INTEGER NOT NULL,
    SubmissionPropertyTypeCode VARCHAR(50) NOT NULL,
    SubmissionPropertyTypeID INTEGER NOT NULL
);

CREATE TABLE Submissions (
    ApplNo VARCHAR(6) NOT NULL,
    SubmissionClassCodeID INTEGER NULL,
    SubmissionType VARCHAR(10) NOT NULL,
    SubmissionNo INTEGER NOT NULL,
    SubmissionStatus VARCHAR(2) NULL,
    SubmissionStatusDate DATE NULL,
    SubmissionsPublicNotes TEXT NULL,
    ReviewPriority VARCHAR(20)
);

CREATE VIEW v_DrugApplications AS 
SELECT a.ApplNo,
    a.ApplType,
    a.SponsorName,
    s.SubmissionNo,
    s.SubmissionType,
    s.SubmissionStatus,
    s.SubmissionStatusDate,
    s.ReviewPriority,
    p.ProductNo,
    p.DrugName,
    p.ActiveIngredient,
    p.Form,
    p.Strength,
    ml.MarketingStatusDescription
FROM Applications a
JOIN Submissions s ON (a.ApplNo = s.ApplNo)
JOIN SubmissionClass_Lookup l ON (l.SubmissionClassCodeID = s.SubmissionClassCodeID)
JOIN Products p ON (p.ApplNo = a.ApplNo)
JOIN MarketingStatus m ON (m.ApplNo = p.ApplNo AND m.ProductNo = p.ProductNo)
JOIN MarketingStatus_Lookup ml ON (m.MarketingStatusID = ml.MarketingStatusID)
ORDER BY a.ApplNo,
    s.SubmissionNo,
    s.SubmissionStatusDate;
