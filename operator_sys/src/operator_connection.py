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

        try:
            self.cnx = pymysql.connect(
                host='localhost',
                user='default_account',
                password='rbstore_guest',
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
                print('[ERROR] Connection Failed, Error: %d: %s' % (e.args[0], e.args[1]))
                print('[Status] Connection Failed:{}'.format(e))

    def sign_up(self):
        new_user = input("new_user: ", )
        new_password = input("passwd: ")
        # Create a new user and set the password
        query = "CREATE USER %s@'%%' IDENTIFIED BY %s"
        self.cur.execute(query, (new_user, new_password))
        self.cnx.commit()

        print(f"User '{new_user}' created with password '{new_password}'.")

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
    def login(self):

        print("### Please Login With Your Username and Password ###")
        user_name = input("username: ")
        passwd = input("password: ")
        # TO DO Switch account
        print("You have successfully logged in.")

    def main(self):
        self.prompt_user_interface(self)
        if self.status is True:
            self.user_choice()


if __name__ == '__main__':
    database = DatabaseConnection()
    database.main()
