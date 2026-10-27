WHENEVER SQLERROR EXIT SQL.SQLCODE

DECLARE
    v_user        VARCHAR2(128);
    v_password    VARCHAR2(4000);
    v_pdb         VARCHAR2(128);
    v_quoted_user VARCHAR2(300);
    v_count       PLS_INTEGER;
BEGIN
    DBMS_SYSTEM.GET_ENV('ORACLE_APP_USERNAME', v_user);
    DBMS_SYSTEM.GET_ENV('ORACLE_APP_PASSWORD', v_password);
    DBMS_SYSTEM.GET_ENV('ORACLE_PDB', v_pdb);

    IF v_user IS NULL OR v_password IS NULL OR v_pdb IS NULL THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'ORACLE_APP_USERNAME, ORACLE_APP_PASSWORD and ORACLE_PDB must be set'
        );
    END IF;

    v_pdb := UPPER(DBMS_ASSERT.SIMPLE_SQL_NAME(v_pdb));

    EXECUTE IMMEDIATE
        'ALTER SESSION SET CONTAINER = ' ||
        DBMS_ASSERT.ENQUOTE_NAME(v_pdb, FALSE);

    v_user := UPPER(DBMS_ASSERT.SIMPLE_SQL_NAME(v_user));
    v_quoted_user := DBMS_ASSERT.ENQUOTE_NAME(v_user, FALSE);

    SELECT COUNT(*)
      INTO v_count
      FROM DBA_USERS
     WHERE USERNAME = v_user;

    IF v_count = 0 THEN
        EXECUTE IMMEDIATE
            'CREATE USER ' || v_quoted_user ||
            ' IDENTIFIED BY "' ||
            REPLACE(v_password, '"', '""') || '"';
    ELSE
        EXECUTE IMMEDIATE
            'ALTER USER ' || v_quoted_user ||
            ' IDENTIFIED BY "' ||
            REPLACE(v_password, '"', '""') || '" ACCOUNT UNLOCK';
    END IF;

    EXECUTE IMMEDIATE
        'GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, ' ||
        'CREATE SEQUENCE, CREATE PROCEDURE, CREATE TRIGGER TO ' ||
        v_quoted_user;

    EXECUTE IMMEDIATE
        'ALTER USER ' || v_quoted_user ||
        ' QUOTA UNLIMITED ON USERS';
END;
/

EXIT SUCCESS
