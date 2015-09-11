<?php
error_reporting(0);
session_set_cookie_params(1500, '/', '', false);
/* Create signon session */
$session_name = 'DaoCloudPMA';
$redirect_uri = 'https://dashboard.daocloud.io/services';
session_name($session_name);
session_start();

if (isset($_POST['token']) && isset($_POST['uuid']) && $_POST['org']) {
    $uri = sprintf('https://api.daocloud.io/v1/service-instances/%s', $_POST['uuid']);
    $auth_header = array(sprintf('Authorization: %s', $_POST['token']),
                         sprintf('UserNameSpace: %s', $_POST['org'])
                         );
    
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $uri);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $auth_header);
    $response = curl_exec($ch);
    curl_close($ch);
    
    $service_info = json_decode($response, true);
    $mysql_conf = array();
    foreach ($service_info['config'] as $config) {
        switch ($config['config_name']) {
            case '3306/tcp':
                preg_match('/(?P<host>(\d{1,3}\.){3}\d{1,3}):(?P<port>\d+)/', $config['config_value'], $matchd);
                $mysql_conf['host'] = $matchd['host'];
                $mysql_conf['port'] = $matchd['port'];
                break;

            case 'USERNAME':
                $mysql_conf['username'] = $config['config_value'];
                break;

            case 'PASSWORD':
                $mysql_conf['password'] = $config['config_value'];
                break;
        }
    }
    $_SESSION['PMA_single_signon_user'] = $mysql_conf['username'];
    $_SESSION['PMA_single_signon_password'] = $mysql_conf['password'];
    $_SESSION['PMA_single_signon_host'] = $mysql_conf['host'];
    $_SESSION['PMA_single_signon_port'] = $mysql_conf['port'];
    $_SESSION['DAO_service_name'] = $service_info['service_instance_name'];
    
    session_write_close();
    header('Location: ./index.php');
    exit();
} else {
    session_destroy();
    header(sprintf('Location: %s', $redirect_uri));
}
?>