/// <reference types="astro/client" />

declare module "*/papers.yaml" {
  const value: {
    papers: {
      title: string;
      authors: string;
      publisher: string;
      href: string;
      year: number;
      date?: string;
    }[];
  };
  export default value;
}
