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

    def sign_up(self):
        # new_user = input("new_user: ", )
        # new_password = input("passwd: ")
        # Create a new user and set the password
        # query = "CREATE USER %s@'localhost' IDENTIFIED BY %s"
        # self.cur.execute(query, (new_user, new_password))
        # self.cnx.commit()
        print('Please Enter Info For Sign Up:')
        new_user = input('new_user: ', )
        new_password = input('passwd: ')
        new_name = input('your name: ')
        new_address = input('your address: ')
        new_phone = input('your phone number: ')
        new_sex = input('your sex: ')
        new_date_birth = input('your birth(year-mm-dd): ')

        self.cur.callproc('create_account',
                          [new_user,
                           new_password,
                           new_name,
                           new_address,
                           new_phone,
                           new_sex,
                           new_date_birth])
        self.cnx.commit()
        print(f"User '{new_user}' created with password '{new_password}'.")

        # Close guest account, and prepare to connect new account
        self.status = False
        self.cur.close()
        self.cnx.close()

        # Login new account
        self.login(self)

    @staticmethod
    def prompt_user_interface(self):
        if self.status is True:
            print('------------ Welcome To Sale System ------------')
            print('Please Enter Number To Goto Your Windows:')
            print('[1]: Sign Up (If You Do Not Have A Account.)')
            print('[2]: Login')

    def user_choice(self):
        user_input = input('Enter your choice: ')
        match user_input:
            case '1':
                self.sign_up()
            case '2':
                self.login(self)
            case _:
                print('Error Select, Please Select Again. (ONLY [1] and [2] OPTIONS.)')

        return user_input

    @staticmethod
    def welcome(user_name):
        print("[%s] Welcome to use Robot Sale System" % user_name)
        print("You have successfully logged in.")

    @staticmethod
    def login(self):
        print("### Please Login With Your Username and Password ###")
        user_name = input("username: ")
        passwd = input("password: ")

        self.default_account = user_name
        self.default_passwd = passwd
        self.cnx_connection()

        if self.status is True:
            self.welcome(user_name)
            self.control_panel()

    @staticmethod
    def control_panel():
        print('###########################################')
        print('->[1] View Order                          #')
        print('->[2] Return Order                        #')
        print('->[3] View Order                          #')
        print('###########################################')

    def main(self):
        self.prompt_user_interface(self)
        if self.status is True:
            self.user_choice()


if __name__ == '__main__':
    database = DatabaseConnection()
    database.main()
