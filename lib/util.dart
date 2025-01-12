bool hasCommon(Set<int> bigSet, Set<int> smallSet) {
  return smallSet.any((elem) => bigSet.contains(elem));
}