import pymysql


class DatabaseConnection:
    """
    # Content:
    # This project design for online Robot shop operator system.
    # Group: (name, email)
    # Member name:
    ** Andy(Xiang-Yu) Cui：cui.xiangyu@northeastern.edu
    ** Shu-Hao Liu：liu.shuha@northeastern.edu
    """

    def __init__(self):
        self.cur = None  # cur is the cursor of the database (MySQL)
        self.cnx = None  # cnx is the connection of the database (MySQL)
        self.status = False
        self.default_account = 'root'  # 'default_account'
        self.default_passwd = 'Db@5822900'  # 'rbstore_guest'
        self.cnx_connection()

    def cnx_connection(self):
        try:
            self.cnx = pymysql.connect(
                host='localhost',
                user=self.default_account,
                password=self.default_passwd,
                db='rbstore',
                charset='utf8mb4',
                cursorclass=pymysql.cursors.DictCursor
            )
            self.cur = self.cnx.cursor()
            self.status = True
            print('[Status] Connect To Database Successful.')

        except pymysql.err.OperationalError as e:
            # Access denied error
            if e.args[0] == 1045:
                print('Invalid username or password, please try again.')
            else:
                self.status = False
                print('[ERROR] Connection Failed, Error: %d: %s' % (e.args[0], e.args[1]))
                print('[Status] Connection Failed:{}'.format(e))