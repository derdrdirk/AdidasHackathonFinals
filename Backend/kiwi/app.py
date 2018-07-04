import json
from flask import Flask, request
from sqlalchemy.exc import IntegrityError
from sqlalchemy.sql import exists
from Crypto.PublicKey import RSA
from .settings import DB_URL
from .models import db, User, Data, UserInfo, DataScientist, DataAuth


def create_app():
    """
    An flask application factory, as explained here:
    http://flask.pocoo.org/docs/patterns/appfactories/
    """
    new_app = Flask(__name__)
    new_app.config['SQLALCHEMY_DATABASE_URI'] = DB_URL
    new_app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    return new_app


app = create_app()
db.init_app(app)


# This function is used to avoid FrontEnd CORS errors :P
def make_response(data: dict, code: int):
    response = app.response_class(
            response=json.dumps(data),
            status=code,
            mimetype='application/json',
        )
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'GET,PUT,POST,DELETE,OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Authorization, Content-Length, X-Requested-With, X-Auth-Token'
    return response


@app.route('/')
def hello_world():
    return 'Hello, World!'


@app.route('/create_db')
def create_db():
    db.create_all()
    return 'Tables created'


@app.route('/drop_db')
def drop_db():
    db.drop_all()
    return 'Tables dropped'


@app.route('/create_user', methods=['POST'])
def create_user():
    content = request.get_json()
    new_key = RSA.generate(2048)
    private_key = new_key.exportKey().decode()
    public_key = new_key.publickey().exportKey().decode()
    user = User(
        email=content.get('email'),
        password=content.get('password'),
        public_key=public_key,
    )
    db.session.add(user)
    try:
        db.session.commit()
    except IntegrityError:
        return make_response({'status': 'Email already exist'}, 409)
    return make_response(
        {
            'status': 'User successfully created',
            'private_key': private_key
        }, 201)


@app.route('/user_info', methods=['POST'])
def create_user_info():
    content = request.get_json()
    user_info = UserInfo(
        user_id=content.get('user_id'),
        sex=content.get('sex'),
        city=content.get('city'),
        age=content.get('age'),
    )
    db.session.add(user_info)
    db.session.commit()
    return make_response({'inserted_data_id': str(user_info.id)}, 201)


@app.route('/users_info', methods=['GET'])
def get_users_info():
    query = db.session.query(UserInfo)
    id = request.args.get('id')
    if id:
        query = query.filter_by(id=id)
    sex = request.args.get('sex')
    if sex:
        query = query.filter_by(sex=sex)
    city = request.args.get('city')
    if city:
        query = query.filter_by(city=city)
    age_from = request.args.get('age_from')
    if age_from:
        query = query.filter(UserInfo.age >= age_from)
    age_to = request.args.get('age_to')
    if age_to:
        query = query.filter(UserInfo.age <= age_to)
    users_infos = query.all()

    if not users_infos:
        return make_response({'error': 'No users matched'}, 200)
    else:
        user_ids = []

        for user_info in users_infos:
            user_ids.append(user_info.user_id)
        return make_response({
            'number of matching users': len(users_infos),
            'user ids': user_ids,
        }, 200)


def generate_demo_public_key():
    demo_key = RSA.generate(4096).publickey().exportKey()
    return demo_key


@app.route('/insert_data', methods=['POST'])
def insert_data():
    r = request.get_json(silent=True)
    user_id = r['user_id']
    user_data = r['data'].encode()
    public_key = db.session.query(User).get(user_id).public_key
    try:
        key = RSA.importKey(public_key.encode())
    except Exception:
        return make_response({'error': 'RSA key format is not supported'}, 406)
    encrypted_data = key.encrypt(user_data, 32)[0]
    db.session.add(Data(
        user_id=user_id,
        data=encrypted_data,
    ))
    db.session.commit()
    return make_response({'inserted_data_id': str(user_id)}, 201)


@app.route('/data_scientist', methods=['POST'])
def create_data_scientist():
    content = request.get_json()
    data_scientist = DataScientist(
        name=content.get('name'),
    )
    db.session.add(data_scientist)
    try:
        db.session.commit()
    except IntegrityError:
        return make_response({'status': 'Name already exist'}, 409)
    return make_response({'Data scientist id': data_scientist.id}, 201)


@app.route('/update_data_auth', methods=['POST', 'DELETE'])
def update_data_auth():
    content = request.get_json()
    user_id = content.get('user_id')
    data_scientist_id = content.get('data_scientist_id')
    data_auth = DataAuth(
        user_id=user_id,
        data_scientist_id=data_scientist_id,
    )
    if request.method == 'POST':
        db.session.add(data_auth)
        db.session.commit()
        return make_response({'Data scientist id': data_scientist_id}, 201)
    elif request.method == 'DELETE':
        db.session.delete(data_auth)
        db.session.commit()
        return make_response({'Data scientist id': data_scientist_id}, 202)


def has_access(data_scientist_id, user_id):
    return db.session.query(exists().where(
        DataAuth.data_scientist_id == data_scientist_id, DataAuth.user_id == user_id
    )).scalar()


@app.route('/has_access', methods=['GET'])
def has_access_endpoint():
    data_scientist_id = request.args.get('data_scientist_id')
    user_id = request.args.get('user_id')
    make_response({'has_access': str(has_access(data_scientist_id, user_id))}, 200)


@app.route('/approved_data_scientists/int:user_id', methods=['GET'])
def approved_data_scientists(user_id):
    data_auths = db.session.query(DataAuth).filter_by(user_id=user_id).all()
    result = []
    for data_auth in data_auths:
        result.append(data_auth.data_scientist_id)
    return make_response({'Approved data scientists ids': result}, 200)


@app.route('/decrypt_data/<int:data_id>', methods=['GET'])
def decrypt_data(data_id):
    data = db.session.query(Data).get(data_id)
    data_scientist_id = request.args.get('data_scientist_id')
    if not has_access(data_scientist_id, data.user_id):
        return make_response({'Data scientist allowed': False}, 401)
    else:
        user = db.session.query(User).get(data.user_id)
        key = RSA.importKey(user.private_key.encode())
        plaintext = key.decrypt(data.data)
        return make_response({'Decrypted_data': plaintext}, 200)


if __name__ == '__main__':
    app.run()
