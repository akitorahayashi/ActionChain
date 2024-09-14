// 無料版:Today Listのざっくりとした使い方:~ページ目:内容
final Map<String, List<Tips>> actionChainTips = {
  "基本機能": [
    Tips(
        titleInCard: "ざっくりとした使い方",
        urlOfThisTutorial: "https://note.com/akitora_hayashi/n/n4729fd209a95"),
    Tips(
        titleInCard: "操作マニュアル",
        urlOfThisTutorial: "https://note.com/akitora_hayashi/n/n8861a6950b06"),
  ],
  "Akiのアプリについて": [
    Tips(
        titleInCard: "TicketとPremium",
        urlOfThisTutorial: "https://note.com/akitora_hayashi/n/na0140184356f"),
    Tips(
        titleInCard: "バグの対処法",
        urlOfThisTutorial: "https://note.com/akitora_hayashi/n/n8910afcb8ad9"),
    Tips(
        titleInCard: "利用規約",
        urlOfThisTutorial: "https://note.com/akitora_hayashi/n/n55e012b38915"),
    Tips(
        titleInCard: "プライバシーポリシー",
        urlOfThisTutorial: "https://note.com/akitora_hayashi/n/n2498f5f813f1"),
  ]
};

class Tips {
  String titleInCard;
  String urlOfThisTutorial;
  Tips({required this.titleInCard, required this.urlOfThisTutorial});
}
