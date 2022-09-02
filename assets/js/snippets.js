export const sortArrOfObjsByPropertyValue = (arr, property, asc = false) => {
  // greater than
  const gt = (a, b) => a[property] > b[property]

  // less than
  const lt = (a, b) => a[property] < b[property]

  const fn = (a, b) => (asc ? gt(a, b) : lt(a, b))
  return arr.sort((a, b) => (fn(a, b) ? 1 : fn(b, a) ? -1 : 0))
}
