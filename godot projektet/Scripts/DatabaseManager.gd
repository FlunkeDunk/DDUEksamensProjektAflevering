extends Node
class_name DatabaseManager

var hhtpRequest: HTTPRequest = HTTPRequest.new()
const serverURL = "https://ddu-gram.dk/ddudatabase.php"
const serverHeaders = ["Content-Type: application/x-www-form-urlencoded", "Cache-Control: max-age=0"]
const secretKey = "1234567890"
var nonce = null
var requestQueue: Array = []
var isRequesting: bool = false

signal leaderboardRecieved(leaderboard)
signal scoreSubmiited

func _init():
	add_child(hhtpRequest)
	hhtpRequest.request_completed.connect(hhtpsRequestCompleted)


func _process(delta):
	if isRequesting:
		return
	if requestQueue.is_empty():
		return
	isRequesting = true
	if nonce == null:
		requestNonce()
	else:
		sendRequest(requestQueue.pop_front())

func hhtpsRequestCompleted(result, responseCode, headers, body):
	isRequesting = false
	if result != HTTPRequest.RESULT_SUCCESS:
		printerr("Error with connection" + str(result))
		return
	
	var responseBody = body.get_string_from_utf8()
	#var jsonObject = JSON.new()
	var response = JSON.parse_string(responseBody)
	if response['error'] != "none":
		printerr("We returned error: " + response['error'])
		return
	if response['command'] == 'get_nonce':
		nonce = response['response']['nonce']
		return
	if response['command'] == 'get_scores':
		leaderboardRecieved.emit(response['response'])
		return
	if response['command'] == 'add_score':
		scoreSubmiited.emit()
		return

func requestNonce():
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data": JSON.stringify({})})
	var body = "command=get_nonce&" + data
	
	var err = hhtpRequest.request(serverURL, serverHeaders, HTTPClient.METHOD_POST, body)
	
	if err != OK:
		printerr("HTTPRequest error:"+ str(err))
		return

func sendRequest(request: Dictionary):
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data": JSON.stringify(request['data'])})
	var body = "command=" + request['command'] + "&" + data
	
	var cnonce = str(Crypto.new().generate_random_bytes(32)).sha256_text()
	
	var clientHash = (nonce + cnonce + body + secretKey).sha256_text()
	nonce = null
	
	var headers = serverHeaders.duplicate()
	headers.push_back("cnonce: " + cnonce)
	headers.push_back("hash: " + clientHash)
	
	var err = hhtpRequest.request(serverURL, headers, HTTPClient.METHOD_POST, body)
	
	if err != OK:
		printerr("HTTPRequest error:"+ str(err))
		return
	

func submitScore(score: int, username: String):
	var command = "add_score"
	var data = {"score": score, "username": username}
	requestQueue.push_back({"command": command, "data": data})

func getLeaderboard():
	var command = "get_scores"
	var data = {"score_offsett": 0, "score_number": 10}
	requestQueue.push_back({"command": command, "data": data})
