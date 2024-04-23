/*************************************************************************************************************
Objects :           Provider ACF Account Setup
Create Date:        2023-03-14
Author:             Marc Henderson
Description:        This script sets up the Provider's account for the Application Control Framework
Called by:          SCRIPT(S):
                      setup/sql/setup.sql
Objects(s):         ROLE:  P_<APP_CODE>_APP_ADMIN
                    WAREHOUSE:      P_<APP_CODE>_ACF_WH
                    DATABASE:       EVENTS_TEST
                    SCHEMA:         EVENTS_TEST.EVENTS
                    PROCEDURE:      EVENTS_TEST.EVENTS.DETECT_EVENT_TABLE
                    TABLE (EVENT):  EVENTS_TEST.EVENTS.EVENTS
Used By:            Provider

Copyright © 2024 Snowflake Inc. All rights reserved

*************************************************************************************************************
SUMMARY OF CHANGES
Date(yyyy-mm-dd)    Author                              Comments
------------------- -------------------                 --------------------------------------------
2023-03-14          Marc Henderson                      Initial build
2023-05-11          Marc Henderson                      Streamlined object creation using APP_CODE parameter
2023-10-27          Marc Henderson                      Added creation of local event table
*************************************************************************************************************/

!print **********
!print Begin 01_account_setup.sql
!print **********

--get current user
SET APP_USER = '"' || CURRENT_USER() || '"';

--set parameter for admin role
SET ACF_ADMIN_ROLE = 'P_&{APP_CODE}_ACF_ADMIN';

--set parameter for warehouse
SET ACF_WH = 'P_&{APP_CODE}_ACF_WH';

USE ROLE ACCOUNTADMIN;
CREATE ROLE IF NOT EXISTS IDENTIFIER($ACF_ADMIN_ROLE);
ALTER ROLE IF EXISTS IDENTIFIER($ACF_ADMIN_ROLE) SET COMMENT = '{"origin":"sf_sit","name":"acf","version":{"major":1, "minor":6},"attributes":{"role":"provider","component":"acf_admin_role"}}';
GRANT ROLE IDENTIFIER($ACF_ADMIN_ROLE) TO ROLE SYSADMIN;
GRANT ROLE IDENTIFIER($ACF_ADMIN_ROLE) TO USER IDENTIFIER($APP_USER);

--grant privileges
GRANT CREATE DATABASE ON ACCOUNT TO ROLE IDENTIFIER($ACF_ADMIN_ROLE);
GRANT CREATE SHARE ON ACCOUNT TO ROLE IDENTIFIER($ACF_ADMIN_ROLE);
GRANT IMPORT SHARE ON ACCOUNT TO ROLE IDENTIFIER($ACF_ADMIN_ROLE);
GRANT EXECUTE TASK ON ACCOUNT TO ROLE IDENTIFIER($ACF_ADMIN_ROLE);
GRANT EXECUTE MANAGED TASK ON ACCOUNT TO ROLE IDENTIFIER($ACF_ADMIN_ROLE);
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE IDENTIFIER($ACF_ADMIN_ROLE);
GRANT CREATE DATA EXCHANGE LISTING ON ACCOUNT TO ROLE IDENTIFIER($ACF_ADMIN_ROLE);
GRANT CREATE APPLICATION ON ACCOUNT TO ROLE IDENTIFIER($ACF_ADMIN_ROLE);
GRANT CREATE APPLICATION PACKAGE ON ACCOUNT TO ROLE IDENTIFIER($ACF_ADMIN_ROLE);

USE ROLE IDENTIFIER($ACF_ADMIN_ROLE);

CREATE WAREHOUSE IF NOT EXISTS IDENTIFIER($ACF_WH) WITH WAREHOUSE_SIZE = 'MEDIUM' 
  COMMENT = '{"origin":"sf_sit","name":"acf","version":{"major":1, "minor":6},"attributes":{"role":"provider","component":"acf_warehouse"}}';

--unset vars
UNSET (APP_USER, ACF_ADMIN_ROLE, ACF_WH);

!print **********
!print End 01_account_setup.sql
!print **********