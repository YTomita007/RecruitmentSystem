export default {
  name: "app",
  data() {
    return {
      list: [], // 最新状態はここにコピーされる
      name: "", // 名前
      message: "" // 送信メッセージ
    };
  },
  created() {
    this.listen();
  },
  methods: {
    // データベースの変更を購読、最新状態をlistにコピーする
    listen() {
      firebase
        .database()
        .ref("myBoard/")
        .on("value", snapshot => {
          // eslint-disable-line
          if (snapshot) {
            const rootList = snapshot.val();
            let list = [];
            Object.keys(rootList).forEach((val, key) => {
              rootList[val].id = val;
              list.push(rootList[val]);
            });
            this.list = list;
          }
        });
    },
    sendMessage() {
      // 空欄の場合は実行しない
      if (!this.name || !this.message) return;
      // 送信
      firebase
        .database()
        .ref("myBoard/")
        .push({
          name: this.name,
          message: this.message
        });
      // 送信後inputを空にする
      // this.name = "";
      this.message = "";
    }
  }
};
