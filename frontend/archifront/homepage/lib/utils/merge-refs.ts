export default function mergeRefs(...refs: any[]): any {
  return (node: any) => {
    refs.forEach(ref => {
      if (typeof ref === 'function') {
        ref(node);
      } else {
        ref && (ref.current = node);
      }
    });
  };
}
