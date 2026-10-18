WHENEVER SQLERROR EXIT SQL.SQLCODE

ALTER SESSION SET CONTAINER = PRODPDB1;

DECLARE
    v_user       VARCHAR2(128);
    v_password   VARCHAR2(4000);
    v_count      PLS_INTEGER;
    v_quoted_user VARCHAR2(300);
BEGIN
    DBMS_SYSTEM.GET_ENV('ORACLE_USERNAME', v_user);
    DBMS_SYSTEM.GET_ENV('ORACLE_PWD', v_password);

    IF v_user IS NULL OR v_password IS NULL THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'APP_USER and APP_USER_PWD must be set in the environment'
        );
    END IF;

    v_user := UPPER(v_user);
    v_user := DBMS_ASSERT.SIMPLE_SQL_NAME(v_user);
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
    END IF;

    EXECUTE IMMEDIATE
        'GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, ' ||
        'CREATE SEQUENCE, CREATE PROCEDURE, CREATE TRIGGER TO ' ||
        v_quoted_user;

    EXECUTE IMMEDIATE
        'ALTER USER ' || v_quoted_user ||
        ' QUOTA UNLIMITED ON USERS';

    ORDS.ENABLE_SCHEMA(
        p_enabled             => TRUE,
        p_schema              => v_user,
        p_url_mapping_type    => 'BASE_PATH',
        p_url_mapping_pattern => LOWER(v_user),
        p_auto_rest_auth      => FALSE
    );

    COMMIT;
END;
/
